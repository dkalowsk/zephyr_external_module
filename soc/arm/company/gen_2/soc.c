#include <kernel.h>
#include <device.h>
#include <init.h>
#include <soc.h>
#include <arch/cpu.h>
/* Add arch/hal specific includes here */

/**
 *
 * @brief Pre-Kernel hardware init
 *
 * @return 0
 */

static int company_gen_1_init(const struct device *arg)
{
    ARG_UNUSED(arg);
    return 0;
}

SYS_INIT(company_gen_1_init, PRE_KERNEL_1, 0);
