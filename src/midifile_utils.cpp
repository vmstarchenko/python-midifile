#include "midifile_utils.hpp"

namespace smf {

MidiEventList* at_ptr(MidiFile& obj, int idx) {
    return &obj[idx];
}

MidiEvent* at_ptr(MidiEventList& obj, int idx) {
    return &obj[idx];
}

}
