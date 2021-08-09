package basic;

simple Toc
{
    parameters:
        @class(TicToc);
        string tone = default("toc!");
        double frequency @unit(Hz) = default(220 Hz);

    gates:
        input sink;
        output source;
}