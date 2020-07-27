///////////////////////////////////////////////////////////////////
//*-------------------------------------------------------------*//
//| Part of the Game Jolt API C++ Library (http://gamejolt.com) |//
//*-------------------------------------------------------------*//
//| Released under the zlib License                             |//
//| More information available in the readme file               |//
//*-------------------------------------------------------------*//
///////////////////////////////////////////////////////////////////

#pragma push_macro("noexcept")
#pragma push_macro("override")
#pragma push_macro("final")
#pragma push_macro("delete_func")
#pragma push_macro("constexpr_func")
#pragma push_macro("constexpr_var")

#undef noexcept
#undef override
#undef final
#undef delete_func
#undef constexpr_func
#undef constexpr_var

// wrap missing compiler functionality
#if defined(_GJ_MSVC_)
    #if (_GJ_MSVC_) < 1800
        #define delete_func
    #else
        #define delete_func = delete
    #endif
    #if (_GJ_MSVC_) < 1700
        #define final
    #endif
    #define noexcept       throw()
    #define constexpr_func inline
    #define constexpr_var  const
#else
    #define delete_func    = delete
    #define constexpr_func constexpr
    #define constexpr_var  constexpr
#endif
#if defined(_GJ_GCC_)
    #if (_GJ_GCC_) < 40700
        #define override
        #define final
    #endif
#endif

#if defined(_GJ_MSVC_)

    #pragma warning(push)

    // disable unwanted compiler warnings (with /W4)
    #pragma warning(disable : 4100)   //!< unreferenced formal parameter
    #pragma warning(disable : 4127)   //!< constant conditional expression
    #pragma warning(disable : 4201)   //!< nameless struct or union
    #pragma warning(disable : 4244)   //!< implicit conversion to smaller integer precision
    #pragma warning(disable : 4267)   //!< implicit conversion of std::size_t

    // enable additional compiler warnings (https://msdn.microsoft.com/library/23k5d385)
    #pragma warning(default : 4191 4264 4265 4287 4289 4296 4302 4311 4355 4388 4548 4555 4557 4738 4826 4837 4928 4946)

#endif