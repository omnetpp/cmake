#pragma once

#include <omnetpp/csimplemodule.h>

namespace basic
{

class TicToc : public omnetpp::cSimpleModule
{
public:
    void initialize() override;
    void handleMessage(omnetpp::cMessage*) override;

protected:
    void sendTone();

private:
    omnetpp::cGate* sourceGate;
};

} // namespace basic
