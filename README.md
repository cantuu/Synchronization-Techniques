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

Com uma série de sincronizadores disponíveis para a utilização em sistemas de comunicação, qual deles é o mais indicado a ser utilizado em um determinado cenário? Com o auxílio da ferramenta GNU Octave, o presente trabalho visa responder esta pergunta. Os sincronizadores serão testados em diferentes cenários, onde parâmetros como por exemplo o tipo de modulação empregada, o modelo de canal de transmissão, a quantidade de amostras por símbolos e parâmetros internos dos sincronizadores serão variados, e uma análise de desempenho será realizada, afim de obter o melhor sincronizador para diferentes casos de uso.

## Objetivos
- Desenvolvimento de uma biblioteca de funções de sincronismo de símbolo na plataforma GNU Octave, semelhante a biblioteca já existe na plataforma Matlab, o `comm.SymbolSynchronizer`; 
- Análise e comparações dos sincronizadores de símbolo em diferentes cenários de comunicação, utilizando a biblioteca previamente desenvolvida; 
- Submissão de um Patch no GNU Radio, onde todos os sincronizadores desenvolvidos serão submetidos, juntamente com recomendações de parâmetros para a utilização de cenários de rádio definido por software. 

## Estrutura da Fundamentação Teórica
Para atingir todos os objetivos previamente traçados, uma base teórica é fundamental para qualquer projeto que será desenvolvido. A Estrutura da fundamentação teórica deste projeto visa abordar desde os princípios básicos de comunicações digitais e a importância de sincronizadores, até as plataformas em que os mesmos serão implementados no decorrer do trabalho. Os principais tópicos da Estrutura da Fundamentação Teórica são:   
- Problemática do Sincronismo de símbolo: O que é, e porque o sincronismo é uma parte fundamental de qualquer sistema de comunicação digital;
- Principais algoritmos:
	* Zero Crossing;
	* Gardner;
	* Early-Late;
	* Mueller & Muller;
- Utilização da plataforma GNU Octave: Qual a motivação da utilização desta plataforma;
- Utilização da plataforma GNU Radio: De volta ao princípio do projeto. Porque iremos trabalhar em duas plataformas distintas. 

### Preparando o ambiente
Para a realização das análises propostas por este projeto, é necessário a configuração de um ambiente de trabalho.
-  Caso você não possua a plataforma GNU Octave instalada em sua máquina, ela pode ser instalada diretamente do [Site Oficial](https://www.gnu.org/software/octave/), onde uma versão mais recente é instalada. Caso você já possua o GNU Octave, verifique a versão do mesmo, pois recomendamos a utilização de uma versão mais recente da plataforma.
- Além da plataforma, o projeto faz o uso de pacotes extras do GNU Octave, disponibilizados pelo Octave Forge (mais informações podem ser encontradas [aqui](https://octave.sourceforge.io/)). Os pacotes que devem ser instalados são:
	* [Control](https://octave.sourceforge.io/control/index.html): ;
	* [Signal](https://octave.sourceforge.io/signal/index.html);
	* [Symbolic](https://octave.sourceforge.io/symbolic/index.html);

### Compilando os arquivos


