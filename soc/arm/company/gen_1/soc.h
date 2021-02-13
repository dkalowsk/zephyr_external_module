#ifndef _SOC__H_
#define _SOC__H_

#include <sys/util.h>

#ifndef _ASMLANGUAGE

#include <devicetree.h>

#ifdef __cplusplus
extern "C" {
#endif

/* =========================================================================================================================== */
/* ================                                Interrupt Number Definition                                ================ */
/* =========================================================================================================================== */

#if CONFIG_SOC_IS_SOLDERED
typedef enum IRQn
{
    /* ===========================================  SoC Specific Interrupt Numbers  ============================================= */
} IRQn_Type;
#elif CONFIG_SOC_IS_SOCKETED
typedef enum IRQn
{
    /* ===========================================  SoC Specific Interrupt Numbers  ============================================= */
} IRQn_Type;
#else
#error "CONFIG_SOC_IS_SOLDERED or CONFIG_SOC_IS_SOCKETED must be set. " \
       "Check your Kconfig, and the autoconf.h that it generated."
#endif

/* =========================================================================================================================== */
/* ================                           Processor and Core Peripheral Section                           ================ */
/* =========================================================================================================================== */

#endif /* !_ASMLANGUAGE */

#endif /* _SOC__H_ */
