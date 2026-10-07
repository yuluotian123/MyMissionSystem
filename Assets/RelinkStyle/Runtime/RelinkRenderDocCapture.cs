using System;
using System.Runtime.InteropServices;

namespace MyMission.Rendering
{
    /// <summary>Optional application API; never loads or injects RenderDoc itself.</summary>
    internal static class RelinkRenderDocCapture
    {
        [DllImport("kernel32",CharSet=CharSet.Unicode)] static extern IntPtr GetModuleHandle(string name);
        [DllImport("kernel32",CharSet=CharSet.Ansi)] static extern IntPtr GetProcAddress(IntPtr module,string name);
        [UnmanagedFunctionPointer(CallingConvention.Cdecl)] delegate int GetAPI(int version,out IntPtr api);
        [UnmanagedFunctionPointer(CallingConvention.Cdecl)] delegate void SetPath([MarshalAs(UnmanagedType.LPStr)] string path);
        [UnmanagedFunctionPointer(CallingConvention.Cdecl)] delegate void StartCapture(IntPtr device,IntPtr window);
        [UnmanagedFunctionPointer(CallingConvention.Cdecl)] delegate uint EndCapture(IntPtr device,IntPtr window);
        static IntPtr api;
        static bool attempted;
        static T Function<T>(int index) where T:class => Marshal.GetDelegateForFunctionPointer(Marshal.ReadIntPtr(api,index*IntPtr.Size),typeof(T)) as T;
        public static bool Begin(string path) {
#if UNITY_EDITOR_WIN || UNITY_STANDALONE_WIN
            if(!attempted) {
                attempted=true; var module=GetModuleHandle("renderdoc.dll");
                if(module!=IntPtr.Zero) {
                    var address=GetProcAddress(module,"RENDERDOC_GetAPI");
                    if(address!=IntPtr.Zero) Marshal.GetDelegateForFunctionPointer<GetAPI>(address)(10600,out api);
                }
            }
            if(api==IntPtr.Zero)return false;
            // Verified against RenderDoc v1.46 renderdoc_app.h, API 1.6.0 layout.
            Function<SetPath>(11)(path);Function<StartCapture>(19)(IntPtr.Zero,IntPtr.Zero);return true;
#else
            return false;
#endif
        }
        public static void End() {if(api!=IntPtr.Zero) Function<EndCapture>(21)(IntPtr.Zero,IntPtr.Zero);}
    }
}
