#include "TicToc.h"

// Generated message header
// Look in the opp_messages subdirectory of your build directory
#include "Tone_m.h"

namespace basic
{

Define_Module(TicToc)

void TicToc::initialize()
{
    sourceGate = gate("source");
    if (par("tone").stdstringValue() == "tic!") {
        sendTone();
    } else {
        EV_INFO << "I am waiting for an input tone first!\n";
    }
}

void TicToc::handleMessage(omnetpp::cMessage* msg)
{
    Tone* tone = dynamic_cast<Tone*>(msg);
    if (tone && tone->getName() != par("tone").stdstringValue()) {
        sendTone();
    }
    delete msg;
}

void TicToc::sendTone()
{
    Tone* tone = new Tone();
    tone->setName(par("tone"));
    tone->setFrequency(par("frequency"));
    sendDelayed(tone, omnetpp::SimTime { 500, omnetpp::SIMTIME_MS }, sourceGate);
}

} // namespace basic
