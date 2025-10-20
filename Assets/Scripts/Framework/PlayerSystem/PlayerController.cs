using UnityEngine;
using UnityEngine.InputSystem;

namespace Framework.GamePlay
{
    [RequireComponent(typeof(CharacterController))]
    [RequireComponent(typeof(PlayerInput))]
    public class PlayerController : MonoBehaviour
    {
        [Header("移动设置")]
        [SerializeField] private float walkSpeed = 3f;
        [SerializeField] private float runSpeed = 6f;
        [SerializeField] private float acceleration = 10f;
        [SerializeField] private float deceleration = 10f;

        [Header("重力设置")]
        [SerializeField] private float gravity = -9.81f;
        [SerializeField] private float groundCheckDistance = 0.1f;
        [SerializeField] private LayerMask groundLayerMask = 1;

        [Header("动画设置")]
        [SerializeField] private Animator animator;

        // 组件引用
        private CharacterController characterController;
        private PlayerInput playerInput;
        private PlayerInputActions inputActions;
        private SpriteRenderer characterSprite;

        // 移动相关变量
        private Vector2 moveInput;
        private Vector3 moveDirection;
        private Vector3 velocity;
        private float currentSpeed;
        private bool isRunning;
        private bool isGrounded;

        // 动画参数哈希值
        private static readonly int SpeedHash = Animator.StringToHash("Speed");
        private static readonly int IsRunningHash = Animator.StringToHash("IsRunning");
        private static readonly int IsGroundedHash = Animator.StringToHash("IsGrounded");

        private void Awake()
        {
            // 获取组件引用
            characterController = GetComponent<CharacterController>();
            playerInput = GetComponent<PlayerInput>();
            characterSprite = GetComponentInChildren<SpriteRenderer>();

            // 创建输入动作实例
            inputActions = new PlayerInputActions();

            // 如果没有指定动画器，尝试从子对象中找到
            if (animator == null)
            {
                animator = GetComponentInChildren<Animator>();
            }
        }

        private void OnEnable()
        {
            // 启用输入动作
            inputActions.Enable();

            // 订阅输入事件
            inputActions.Player.Move.performed += OnMovePerformed;
            inputActions.Player.Move.canceled += OnMoveCanceled;
            inputActions.Player.Run.performed += OnRunPerformed;
            inputActions.Player.Run.canceled += OnRunCanceled;
        }

        private void OnDisable()
        {
            // 取消订阅输入事件
            inputActions.Player.Move.performed -= OnMovePerformed;
            inputActions.Player.Move.canceled -= OnMoveCanceled;
            inputActions.Player.Run.performed -= OnRunPerformed;
            inputActions.Player.Run.canceled -= OnRunCanceled;

            // 禁用输入动作
            inputActions.Disable();
        }

        private void FixedUpdate()
        {
            // 检查是否在地面上
            CheckGrounded();

            // 处理移动
            HandleMovement();

            // 应用重力
            ApplyGravity();

            // 移动角色
            characterController.Move(velocity * Time.deltaTime);

            // 更新动画
            UpdateAnimations();
        }

        #region 输入处理

        private void OnMovePerformed(InputAction.CallbackContext context)
        {
            moveInput = context.ReadValue<Vector2>();
        }

        private void OnMoveCanceled(InputAction.CallbackContext context)
        {
            moveInput = Vector2.zero;
        }

        private void OnRunPerformed(InputAction.CallbackContext context)
        {
            isRunning = true;
        }

        private void OnRunCanceled(InputAction.CallbackContext context)
        {
            isRunning = false;
        }

        #endregion

        #region 移动处理

        private void HandleMovement()
        {
            // 计算移动方向（世界坐标）
            moveDirection = new Vector3(moveInput.x, 0f, moveInput.y);

            // 如果有移动输入
            if (moveDirection.magnitude > 0.1f)
            {
                // 确定目标速度
                float targetSpeed = isRunning ? runSpeed : walkSpeed;

                // 平滑加速到目标速度
                currentSpeed = Mathf.MoveTowards(currentSpeed, targetSpeed, acceleration * Time.deltaTime);

                // 应用移动
                Vector3 targetVelocity = moveDirection.normalized * currentSpeed;
                velocity.x = targetVelocity.x;
                velocity.z = targetVelocity.z;

                // 旋转角色面向移动方向
                if (moveDirection != Vector3.zero)
                {
                    if (velocity.x > 0)
                        characterSprite.flipX = false;
                    else if (velocity.x < 0)
                        characterSprite.flipX = true;
                }
            }
            else
            {
                // 没有输入时减速
                currentSpeed = Mathf.MoveTowards(currentSpeed, 0f, deceleration * Time.deltaTime);

                // 应用减速
                velocity.x = Mathf.MoveTowards(velocity.x, 0f, deceleration * Time.deltaTime);
                velocity.z = Mathf.MoveTowards(velocity.z, 0f, deceleration * Time.deltaTime);
            }
        }

        private void CheckGrounded()
        {
            // 使用CharacterController的isGrounded属性
            isGrounded = characterController.isGrounded;

            // 也可以使用射线检测进行更精确的地面检测
            if (!isGrounded)
            {
                Vector3 rayOrigin = transform.position + Vector3.up * 0.1f;
                isGrounded = Physics.Raycast(rayOrigin, Vector3.down, groundCheckDistance + 0.1f, groundLayerMask);
            }
        }

        private void ApplyGravity()
        {
            if (isGrounded && velocity.y < 0)
            {
                // 在地面上时，保持一个小的向下速度以确保贴地
                velocity.y = -2f;
            }
            else
            {
                // 应用重力
                velocity.y += gravity * Time.deltaTime;
            }
        }

        #endregion

        #region 动画处理

        private void UpdateAnimations()
        {
            if (animator == null) return;

            // 计算速度百分比（0-1之间）
            float speedPercent = currentSpeed / runSpeed;

            // 更新动画参数
            animator.SetFloat(SpeedHash, speedPercent);
            animator.SetBool(IsRunningHash, isRunning && moveInput.magnitude > 0.1f);
            animator.SetBool(IsGroundedHash, isGrounded);
        }

        #endregion

        #region 公共方法

        /// <summary>
        /// 设置玩家位置
        /// </summary>
        /// <param name="position">目标位置</param>
        public void SetPosition(Vector3 position)
        {
            characterController.enabled = false;
            transform.position = position;
            characterController.enabled = true;
        }

        /// <summary>
        /// 获取当前移动速度
        /// </summary>
        /// <returns>当前速度</returns>
        public float GetCurrentSpeed()
        {
            return currentSpeed;
        }

        /// <summary>
        /// 获取是否在奔跑
        /// </summary>
        /// <returns>是否在奔跑</returns>
        public bool IsRunning()
        {
            return isRunning && moveInput.magnitude > 0.1f;
        }

        /// <summary>
        /// 获取是否在移动
        /// </summary>
        /// <returns>是否在移动</returns>
        public bool IsMoving()
        {
            return moveInput.magnitude > 0.1f;
        }

        /// <summary>
        /// 获取是否在地面上
        /// </summary>
        /// <returns>是否在地面上</returns>
        public bool IsGrounded()
        {
            return isGrounded;
        }

        /// <summary>
        /// 启用/禁用玩家控制
        /// </summary>
        /// <param name="enabled">是否启用</param>
        public void SetControlEnabled(bool enabled)
        {
            playerInput.enabled = enabled;

            if (!enabled)
            {
                // 禁用控制时停止移动
                moveInput = Vector2.zero;
                isRunning = false;
            }
        }

        #endregion

        #region 调试

        private void OnDrawGizmosSelected()
        {
            // 绘制地面检测射线
            Gizmos.color = isGrounded ? Color.green : Color.red;
            Vector3 rayOrigin = transform.position + Vector3.up * 0.1f;
            Gizmos.DrawRay(rayOrigin, Vector3.down * (groundCheckDistance + 0.1f));

            // 绘制移动方向
            if (moveDirection.magnitude > 0.1f)
            {
                Gizmos.color = Color.blue;
                Gizmos.DrawRay(transform.position, moveDirection.normalized * 2f);
            }
        }

        #endregion
    }
}
