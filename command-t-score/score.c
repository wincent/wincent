#include <Python.h>

/**
 * Test with:
 *
 *      pip3 install .
 *
 * Then, in the `python3` REPL:
 *
 *      import score
 *      score.calc("foo", "foobar")
 */

static PyObject *score_calc(PyObject *self, PyObject *args) {
    const char *needle;
    const char *haystack;

    // See: https://docs.python.org/3/c-api/arg.html
    if (!PyArg_ParseTuple(args, "ss", &needle, &haystack)) {
        return NULL;
    }

    // TODO: implement
    return PyLong_FromLong(1000L);
}

#define SENTINEL {NULL, NULL, 0, NULL}

static PyMethodDef module_methods[] = {
    {
        "calc",
        score_calc,
        METH_VARARGS,
        "Calculate a fuzzy match score for 'needle' in 'haystack'."
    },
    SENTINEL
};

// See: https://docs.python.org/3/c-api/module.html#initializing-modules
static struct PyModuleDef module_def = {
   PyModuleDef_HEAD_INIT,
   "score", // Module name.
   NULL, // Module docstring.
   -1, // No per-interpreter state.
   module_methods,
   NULL, // Single-phase initialization.
   NULL, // GC traversal function.
   NULL, // GC clearing function.
   NULL // Function to call when module is deallocated.
};

PyMODINIT_FUNC PyInit_score(void) {
    Py_Initialize();
    PyObject *m = PyModule_Create(&module_def);
    if (!m) {
        return NULL;
    }
    return m;
}
