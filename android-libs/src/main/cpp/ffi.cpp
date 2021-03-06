// Part of measurement-kit <https://measurement-kit.github.io/>.
// Measurement-kit is free software. See AUTHORS and LICENSE for more
// information on the copying conditions.

#include "io_ooni_mk_MKAsyncTask.h"
#include "io_ooni_mk_MKEvent.h"

#include <limits.h>

#include <measurement_kit/ffi.h>

#include "mkall_util.h"

MKALL_NEW_WITH_STRING_ARGUMENT(MKAsyncTask_Start, mk_task_start)

MKALL_GET_BOOLEAN(MKAsyncTask_IsDone, mk_task_is_done, mk_task_t)

MKALL_GET_POINTER(MKAsyncTask_WaitForNextEvent,
                  mk_task_wait_for_next_event,
                  mk_task_t)

MKALL_CALL(MKAsyncTask_Interrupt, mk_task_interrupt, mk_task_t)

MKALL_DELETE(MKAsyncTask_Destroy, mk_task_destroy, mk_task_t)

MKALL_GET_STRING(MKEvent_Serialize, mk_event_serialize, mk_event_t)

MKALL_DELETE(MKEvent_Destroy, mk_event_destroy, mk_event_t)
