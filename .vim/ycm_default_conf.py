gs = ['-Wall',
         '-Wextra',
         '-Werror',
         '-fexceptions',
         '-std=c++11',
         '-I', '/home/yazevnul/arc/arcadia',
         '-I', '/home/yazevnul/arc/arcadia/contrib/libs/stlport/stlport-5.1.4',
         '-isystem', '/home/yazevnul/.tools/9840231/gcc/include/c++/4.8.2',
         '-isystem', '/home/yazevnul/.tools/9840231/gcc/include/c++/4.8.2/x86_64-unknown-linux-gnu/',
         '-DNDEBUG',
         '-g',
         '-pipe',
         '-Wall',
         '-W',
         '-Wno-parentheses',
         '-fexceptions',
         '-m64',
         '-msse',
         '-mssse3',
         '-msse3',
         '-msse2',
         '-fPIC',
         '-D_GNU_SOURCE',
         '-D_FILE_OFFSET_BITS=64',
         '-D_LARGEFILE_SOURCE',
         '-D__STDC_CONSTANT_MACROS',
         '-D__STDC_FORMAT_MACROS',
         '-DGNU',
         '-DNATIVE_INCLUDE_PATH=/place/home/yazevnul/.tools/9840231/gcc/include/c++/4.8.2',
         '-DSSE_ENABLED=1',
         '-DSSSE3_ENABLED=1',
         '-DSSE3_ENABLED=1',
         '-DSSE2_ENABLED=1',
         '-D_THREAD_SAFE',
         '-D_PTHREADS',
         '-D_REENTRANT',
         '-DUSE_INTERNAL_STL',
         '-Woverloaded-virtual',
         '-Wno-deprecated',
         '-Wno-invalid-offsetof',
         '-D__LONG_LONG_SUPPORTED'
        ]

def FlagsForFile( filename, **kwargs ):
    return {'flags': flags,
            'do_cache': True
           }
