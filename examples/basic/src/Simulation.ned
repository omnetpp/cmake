package basic;

network Simulation
{
    submodules:
        tic: Tic {}
        toc: Toc {}

    connections:
        tic.source --> toc.sink;
        tic.sink <-- toc.source;
}