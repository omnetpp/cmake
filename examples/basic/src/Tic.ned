package basic;

simple Tic
{
    parameters:
        @class(TicToc);
        string tone = default("tic!");
        double frequency @unit(Hz) = default(440 Hz);

    gates:
        input sink;
        output source;
}