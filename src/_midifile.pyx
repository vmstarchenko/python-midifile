from libcpp cimport bool
from libcpp.string cimport string
from cython.operator cimport dereference as deref
from libc.stdio cimport printf
from cython.operator cimport dereference as deref, address



cdef extern from "MidiEvent.h" namespace "smf":
    cdef cppclass CMidiEvent "smf::MidiEvent":
        CMidiEvent() except +

        bool isNote() except +
        bool isText() except +
        bool isLyricText() except +
        bool isTrackName() except +
        bool isTimbre() except +

        int getChannelNibble() except +
        int getP1() except +

        string getMetaContent() except +


cdef extern from "MidiEventList.h" namespace "smf":
    cdef cppclass CMidiEventList "smf::MidiEventList":
        CMidiEventList() except +
        int getEventCount() except +
        CMidiEvent& operator[](int) except +


cdef extern from "MidiFile.h" namespace "smf":
    cdef cppclass CMidiFile "smf::MidiFile":
        CMidiFile() except +

        # reading/writing functions:
        bool read(char*) except +
        bool status() except +

        # track-related functions:
        CMidiEventList& operator[](int) except +
        int getTrackCount() except +

        # join/split track functionality:
        void joinTracks() except +

        # ticks-per-quarter related functions:
        int getTicksPerQuarterNote() except +


cdef extern from "midifile_utils.hpp" namespace "smf":
    cdef CMidiEventList* at_ptr(CMidiFile&, int) except +
    cdef CMidiEvent* at_ptr(CMidiEventList&, int) except +


cdef class MidiEvent:
    cdef CMidiEvent* _e

    def __cinit__(self):
        pass

    def is_note(self):
        return self._e.isNote()

    def is_text(self):
        return self._e.isText()

    def is_lyric_text(self):
        return self._e.isLyricText()

    def is_track_name(self):
        return self._e.isTrackName()

    def is_timbre(self):
        return self._e.isTimbre()

    def get_p1(self):
        return self._e.getP1()

    def get_meta_content(self):
        return self._e.getMetaContent()

    def get_channel_nibble(self):
        return self._e.getChannelNibble()


cdef class MidiEventList:
    cdef CMidiEventList* _l

    def __cinit__(self):
        pass

    def __getitem__(self, int idx):
        e = MidiEvent()
        e._e = at_ptr(self._l[0], idx)
        return e

    def __iter__(self):
        i = 0
        event_count = self.get_event_count()
        while i < event_count:
            yield self[i]
            i += 1

    def get_event_count(self):
        return self._l.getEventCount()


cdef class MidiFile:
    cdef CMidiFile _mid

    def __cinit__(self, str path):
        self._mid.read(path.encode())

    def __iter__(self):
        i = 0
        track_count = self.get_track_count()
        while i < track_count:
            yield self[i]
            i += 1

    # reading/writing functions:
    def status(self):
        return self._mid.status()

    # track-related functions:
    def __getitem__(self, int idx):
        l = MidiEventList()
        l._l = at_ptr(self._mid, idx)
        return l

    def get_track_count(self):
        return self._mid.getTrackCount()

    # join/split track functionality:
    def join_tracks(self):
        self._mid.joinTracks()

    # ticks-per-quarter related functions:
    def get_ticks_per_quarter_note(self):
        return self._mid.getTicksPerQuarterNote()
