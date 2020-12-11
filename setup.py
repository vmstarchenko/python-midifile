import glob
from Cython.Build import cythonize
from distutils.extension import Extension
from setuptools import setup

def readme():
    with open('README.rst') as f:
                return f.read()

extensions = [
    Extension(
        "midifile._midifile",
        sources=[
            "src/_midifile.pyx",
            "src/midifile_utils.cpp",
            *glob.glob("src/midifile/src/*.cpp")
        ],
        include_dirs=["src/midifile/include", "src"],
        extra_compile_args=["-O3"],
        # extra_compile_args=["-O0", "-g", "-fsanitize=address", "-Wall", "-static-libasan"],
        language="c++",
    ),
]

setup(
    name='python-midifile',
    version='0.1',
    description='Cython bindings for C++ midifile library',
    long_description=readme(),
    classifiers=[
        'Development Status :: 3 - Alpha',
        'License :: OSI Approved :: MIT License',
        'Programming Language :: Cython',
        'Programming Language :: Python',
        'Programming Language :: Python :: 3.6',
        'Programming Language :: Python :: 3.7',
        'Programming Language :: Python :: 3.8',
        'Programming Language :: Python :: 3.9',
        'Topic :: Multimedia :: Sound/Audio :: MIDI',
    ],
    keywords='music midi midifile audio',
    url='',
    author='Starchenko Vladimir',
    author_email='vmstarchenko@edu.hse.ru',
    license='MIT',
    packages=['midifile'],
    ext_modules=cythonize(
        extensions,
        language_level=3,
        # annotate=True,
    ),
    install_requires=[],
    zip_safe=True,
)
