#ifndef __CORE_COMMON_H
#define __CORE_COMMON_H

#ifdef __cplusplus
  #define   __I   volatile
#else
  #define   __I   volatile const
#endif
#define     __O   volatile
#define     __IO  volatile

#define     __IM  volatile const
#define     __OM  volatile
#define     __IOM volatile

#define __STATIC_INLINE

#endif // __CORE_COMMON_H
