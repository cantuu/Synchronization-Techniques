# Análise de Desempenho de Técnicas de Sincronismo de Símbolo em Sistemas de Telecomunicações

Este trabalho apresenta implementações, análises de desempenho e comparações de técnicas de sincronismo de símbolo em sistemas de telecomunicações, utilizando a plataforma de software livre GNU Octave.

## Autores 
- Gabriel Cozer Cantu, Estudante de Engenharia de Telecomunicações ([Linkedin](https://www.linkedin.com/in/gabriel-cozer-cantu-04b1b413b/));
- Roberto Wanderley da Nóbrega, Professor do Instituto Federal de Santa Catarina ([Lattes](http://lattes.cnpq.br/0845572758065075)).

## Objeto de Estudo
Análise de desempenho de Técnicas de Sincronismo de Símbolo, em sistemas de Telecomunicações.

## Problemática
O sincronismo, em seus diversos aspectos, é fundamental para o correto funcionamento de qualquer sistema de comunicação de dados. O problema do sincronismo consiste em obter no receptor uma réplica do relógio utilizado no transmissor. Em outras palavras, o receptor deve ser capaz de estimar adequadamente o início e o final de cada símbolo.

A necessidade da utilização de sincronizadores de símbolo se dá por um fator de fundamental importância em uma comunicação: o meio de transmissão. Devido às caracteristicas térmicas e imperfeições do tipo de conexão entre extremos, o meio de transmissão adiciona um ruído branco gaussiano e atrasos imprevisíveis ao sinal transmitido. Para que os efeitos adicionados no sinal sejam minimizados, é necessário um processo de filtragem através de um filtro casado, e em seguida, o sinal é passado por uma técnica de sincronismo, para que o receptor consiga identificar o mesmo sinal emitido pelo transmissor. 

Apesar da importância de sincronizadores em sistemas de comunicações, uma das ferramentas mais populares para a implementação de SDR, o GNU Radio, contém apenas um sincronizador implementado em sua biblioteca de funções, o sincronizador Mueller & Muller. Sendo assim, foram implementados os demais algoritmos de sincronismo de símbolo presentes na literatura, primeiramente em GNU Octave, onde se obtem um ambiente mais controlado para testes, e posteriormente na plataforma GNU Radio.

Com uma série de sincronizadores disponíveis para a utilização em sistemas de comunicação, qual deles é o mais indicado a ser utilizado em um determinado cenário? Com o auxílio da ferramenta GNU Octave, o presente trabalho visa responder esta pergunta. Os sincronizadores serão testados em diferentes cenários, onde parâmetros como por exemplo o tipo de modulação empregada, o modelo de canal de transmissão, a quantidade de amostras por símbolos e parâmetros internos dos sincronizadores serão variados, e uma análise de desemprenho será realizada, afim de obter o melhor sincronizador para diferentes casos de uso.

## Objetivos
- Desenvolvimento de uma biblioteca de funções de sincronismo de símbolo na plataforma GNU Octave, semelhante a biblioteca já existe na plataforma Matlab, o `comm.SymbolSynchronizer`; 
- Análise e comparações dos sincronizadores de símbolo em diferentes cenários de comunicação, utilizando a biblioteca previamente desenvolvida; 
- Submissão de um Patch no GNU Radio, onde todos os sincronizadores desenvolvidos serão submetidos, juntamente com recomendações de parâmetros para a utilização de cenários de rádio definido por software. 

### Preparando o ambiente

### Compilando os arquivos

### Analysis Already Completed
- Parameters variation with high signal-noise relation (mi, tau and Early-Late's samples);
- In Early-Late Decided, doesn't matter how many samples are inserted in synchronizator, because the way that the algorithm is written, with decided symbols, will always tend to synchronism;
- Samples per Symbol (sps) variation with high signal-noise relation.


