#include "MidiFile.h"

namespace smf {

MidiEventList* at_ptr(MidiFile& obj, int idx);
MidiEvent* at_ptr(MidiEventList& obj, int idx);

}
