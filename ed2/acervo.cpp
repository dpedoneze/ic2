/*
Sistema de Gerenciamento de uma Biblioteca

Desenvolvido por:
     David Asbahr Pedoneze
     Natalia Buzato Tavares

*/

#include <stdio.h>
#include <conio.h>
#include <stdlib.h>
#include <string.h>

/*
Variaveis Globais:
		  isbn, titulo, autor, ano e isbn_busca do tipo char;
		  out, index do tipo FILE
		  oset, tamanho, tam, header, edit do tipo int
*/

      char isbn[14], titulo[51], autor[14], ano[5], isbn_busca[14];
      FILE *out;
      FILE *index;
      int oset, tamanho, tam;
      int header = 4;
      int edit = 0;

      void geraIndex();

/*Função preenche: Preenche os campos isbn, titulo, autor e ano
com os dados retirados do arquivo. Recebe como parâmetros o
ponteiro do arquivo e o campo a ser preenchido.*/

int preenche(FILE *pout, char *campo){
// Recebe arquivo e o campo a preencher
 char ch;
 int i=0;

 campo[i] = '\0';

 ch = fgetc(pout);
     // le caractere do arquivo
 while ((ch != '#') && (ch != EOF) && (ch != '*')){
     // enquando ch for diferente #,*,EOF
   campo[i] = ch;
           // campo recebe o caractere lido
   i++;
   ch = fgetc(pout);
           // le caractere do arquivo
 }
 campo[i] = '\0';

 return strlen(campo);
     // retorna o tamanho do campo
}


/*Função pesquisaisbn: realiza a busca sequencial por isbn.*/
int pesquisaisbn(void) {
  int i;

  oset = 4;
  fseek(out,4,0);

    // vai para o primeiro registro
  fread(&tamanho, sizeof(int), 1, out);

    // le o tamanho do registro
  i = preenche(out,isbn);

    // i recebe o tamanho do isbn do registro

  while ((strcmp(isbn,isbn_busca) != 0) and (!feof(out))){

    // compara isbn lido com o isbn buscado (0 - true),

    // enquanto nao for EOF
    if (i == 0){

    // se i = 0, então encontrou um registro deletado (*)
      oset = oset + tamanho;

        // oset recebe o tamanho do registro + ele mesmo
      fseek(out,(tamanho-5),1);
      fread(&tamanho, sizeof(int), 1, out);
      i = preenche(out,isbn);
    }else{

        // caso nao seja registro deletado
     oset = oset + tamanho;
     fseek(out,(tamanho-18),1);
           //posiciona o ponteiro no próximo registro
     fread(&tamanho, sizeof(int), 1, out);
           //lê o próximo isbn
     i = preenche(out,isbn);
   }
 }

 system("cls");

 if (feof(out)){
    // se chegar ao fim do arquvio
   printf("Nao existe item com o ISBN buscado.");
   getch();
   return 0;
         // 0 = não encontrou
 }else{
       // se não, imprime na tela o arquivo
  printf("ISBN: %s",isbn);
  preenche(out,titulo);
  printf("\nTitulo: %s",titulo);
  preenche(out,autor);
  printf("\nAutor: %s",autor);
  preenche(out,ano);
  printf("\nAno: %s",ano);
  getch();
  return 1;
              // 1 = encontrou
}
}

/*Função inserir: insere dados no arquivo.*/
int inserir(void){
// caso seja chamado diretamente do menu,

                                        // antes é dado um seek p/ o EOF
	int pos;
  if(edit == 1)
  // caso esteja sendo acessado pela funcao editar()
    strcpy(isbn,isbn_busca);
    // copia isbn_busca para isbn

  if(tam == 0)
  // caso esteja sendo chamada diretamente do menu
    tam = strlen(isbn) + strlen(titulo) + strlen(autor) + strlen(ano) + 8;
    // calcula tamanho total da string

  fwrite(&tam,sizeof(int),1,out);
  // escreve o tamannho no arquivo e seus dados
  fputs(isbn,out);
  fputs("#",out);
  fputs(titulo,out);
  fputs("#",out);
  fputs(autor,out);
  fputs("#",out);
  fputs(ano,out);
  fputs("#",out);
  fseek(out,0,2);
  //vai para o final do arquivo
  pos = ftell(out);
  pos = pos - tam;
  // encontra o offset do registro
  fseek(index,0,2);
  // vai para o final do indice
  fprintf(index, "%s#",isbn);
  // salva o isbn e # no indice
  fwrite(&pos,4,1,index);
  rewind(out);
  // salva o offset do isbn no indice

  system("cls");
  rewind(out);
  if(edit == 0){
    // caso não seja acessado pelo editar()
   printf("Registro inserido com sucesso.");
   getch();
 }
}

/*Função inserir_o: insere dados no arquivo de modo
otimizado, realizanço a busca na lista de espaços vazios disponíveis.*/
int inserir_o(void){
  char lixo;
  int pos,tam,tamr,posant,proxin;
  tamr = 0;
// tamanho inicial do registro
  posant = 0;
// posicao inicial do ponteiro anterior

  tam = strlen(isbn) + strlen(titulo) + strlen(autor) + strlen(ano) + 8;
// tamanho do registro

  fseek(out,0,0);
  fread(&pos,4,1,out);

  while(pos != -1){
  // enquanto existir itens na lista
   fseek(out,pos,0);
      // seek para a posicao da lista
   fread(&tamr,4,1,out);
    // le o tamanho do item atual
   if(tamr >= tam){
    // verifica se o registro a ser inserido cabe

                                          // no registro atual
     proxin = pos;
        // proximo recebe a posicao atual
     fread(&lixo,1,1,out);
        // leitura do * e proxima posicao
     fread(&pos,4,1,out);
     fseek(out,-5,1);
        // volta p/ o inicio do registro

     fputs(isbn,out);
          // grava os dados do registro
     fputs("#",out);
     fputs(titulo,out);
     fputs("#",out);
     fputs(autor,out);
     fputs("#",out);
     fputs(ano,out);
     fputs("#",out);
     fseek(index,0,2);
        // grava o isbn e offset no indice
     fprintf(index, "%s#",isbn);
     fwrite(&proxin,4,1,index);

     fseek(out,posant,0);
        // vai para a pisicao anterior
     fwrite(&pos,4,1,out);
        // grava a proxima posicao na posicao anterior
     fseek(out,0,2);
        // para religar a lista de reg. disponiveis
     return 1;
        // 1 = inserido
   }
   posant = pos +5;
      // soma +5 a posicao anterior (p/ pular o tam e *)
   fread(&lixo,1,1,out);
   fread(&pos,4,1,out);
   getche();
 }

 if(pos == -1){
  // caso não encontre nenhum reg. disponivel
  fseek(out,0,2);
          // seek para final do arquivo e grava os dados
  proxin = ftell(out) - tam;
        // descobre o offset do registro
  fputs(isbn,out);
  fputs("#",out);
  fputs(titulo,out);
  fputs("#",out);
  fputs(autor,out);
  fputs("#",out);
  fputs(ano,out);
  fputs("#",out);
  fseek(index,0,2);
  fprintf(index, "%s#",isbn);
        // grava isbn e offset no indice
  fwrite(&proxin,4,1,index);
}

printf("Livro cadastrado!");
getche();

}

/*Funcão deletar: muda o statusfag do registro para deletado. */
void deletar(void){
  int tam,prox,t,p,ta;
  char i[14];

  fseek(out,0,0);
  fread(&prox,sizeof(int),1,out);
   // le o header

  fseek(out,0,0);
  fwrite(&oset,4,1,out);
   // grava no header o offset do registro a ser deletado

  oset = oset+header;
   // header = 4
  fseek(out,(oset),0);
   // seek para o registro a ser deletado
  fputs("*",out);
   // grava * para constar que o arquivo foi deletado
  fseek(out,(oset+1),0);
  fwrite(&prox,4,1,out);
   // grava o proximo offset da lista

  geraIndex();
   // regria o indice

  if(edit == 0){
   // caso a funcao não seja chamada pela funcao editar()
   printf("\nRegistro deletado!");
   getche();
 }
}

/*Funcão editar: permite alteração nos campos título, autor e ano.
Caso o novo registro seja maior que o anterior, deleta o antigo
e insere o novo no final do arquivo.*/
int editar(){
	char titulonew[51], autornew[14], anonew[5];
	int tamanhonew,oset2;

	printf("\n\nDigite os novos campos a serem inseridos:\n");
	fflush(stdin);
	printf("Titulo: ");
	gets(titulonew);
	printf("Autor: ");
	gets(autornew);
	printf("Ano: ");
	gets(anonew);

	tamanhonew = strlen(isbn) + strlen(titulonew) + strlen(autornew) + strlen(anonew) + 8;
  // calcula novo tamanho
	if (tamanho >= tamanhonew){
  // se o registro antigo for maior ou igual

                                                    // ao novo, insere no mesmo lugar.
   fseek(out,oset,0);
      // seek p/ o registro a editar
   strcpy(titulo,titulonew);
      // copia os novos dados
   strcpy(autor,autornew);
   strcpy(ano,anonew);
   tam = tamanho;
   inserir();
      // chama funcao p/ inserir no arquivo
 }else{
    // se o resgitro antigo for menor

                                                // que o novo...
   deletar();
      //exclui o antigo
   strcpy(titulo,titulonew);
      // copia os novos dados
   strcpy(autor,autornew);
   strcpy(ano,anonew);
   tam = 0;
   fseek(out,0,2);
      //insere o novo no final
   inserir();
 }
}

/*Função compacta: remove os espaços vazios deixados por arquivos deletados.*/
int compacta(void){
 int numero,posicao,p1;
 char ch;
 FILE *novo;
  // seta novo arquivo

 if ((novo = fopen("arquivo2.bin","w+b")) == NULL){
  printf("Nao foi possivel abrir o arquivo");
  getch();
  return 0;
}

rewind(novo);
numero = -1;
fwrite(&numero,sizeof(int),1,novo);
  // seta novo header

posicao = 4;
p1 = 4;

fseek(out,4,0);

fread(&numero,sizeof(int),1,out);
  // le primeiro tamanho do registro

while(!feof(out)){
 ch = fgetc(out);
 if (ch=='*') {
  // caso o registro seja um deletado, entao
   p1 = p1 + numero;
      // pula para o proximo com um seek
   fseek(out,(p1),0);
 }else{
    // caso nao seja deletado
   fseek(out,(p1+4),0);
      // pula seu tamanho
   preenche(out,isbn);
            // salva os seus dados
   preenche(out,titulo);
   preenche(out,autor);
   preenche(out,ano);
   fseek(novo,(posicao),0);
            // posiciona no arquivo novo
   fwrite(&numero,sizeof(int),1,novo);
      // salva seu tamanho
   fputs(isbn,novo);
      // salva seus dados
   fputs("#",novo);
   fputs(titulo,novo);
   fputs("#",novo);
   fputs(autor,novo);
   fputs("#",novo);
   fputs(ano,novo);
   fputs("#",novo);
   posicao = posicao + numero;
            // incrementa posicao no arquivo novo
   p1 = p1 + numero;
            // incrementa posicao no arquivo atual
   fread(&numero,sizeof(int),1,out);
            // le proximo tamanho
 }
}
fclose(novo);
   // fecha arquivos
fclose(out);
remove("arquivo.bin");
   // deleta antigo e salva novo
rename("arquivo2.bin","arquivo.bin");
if ((out = fopen("arquivo.bin","r+b")) == NULL){
  system("cls");
  printf("Nao foi possivel compactar corretamente o arquivo.");
}else{
  system("cls");
  printf("Arquivo compactado corretamente.");
}
getch();
}

/* Gera o Index primario do arquivo salvando ISBN#OFFSET */
void geraIndex(){

	char ch;
	int tamr,h,t,tam2;
	h = 4;

	fclose(index);
	index = fopen("index.bin","w+b");
  // limpa o arquivo de indice reabrindo em w+b

	fseek(out,0,2);
	t = ftell(out);
  // recupera o tamanho do arquivo principal

	fseek(out,header,0);
	fread(&tamr,4,1,out);
  // le o tamanho do primeiro registro

	while(h < t){
  // enquanto h for menor que tamanho do arquivo
   ch = fgetc(out);
   if(ch == '*'){
       // caso seja deletado pula o registro
     fseek(out,h,0);
   }else{
    fseek(out,(h+4),0);
        // caso exista, seek para o isbn
    preenche(out,isbn);
        // le o isbn
    fseek(out,h,0);
    fread(&tamr,4,1,out);
        // le o novo tamanho
    if(strlen(isbn) > 0){
      // caso isbn > 0 (nao deletado)
      fprintf(index, "%s#",isbn);
        // salva isbn e offset no indice
      fwrite(&h,4,1,index);
    }
    h = h + tamr;
        // incrementa ponteiro do arq. principal
  }
}
fseek(index,0,2);
}

/* Busca o ISBN no indice! */
int buscaIndex(char ib[14]){
  char i[14];
  int t,p,ta,achou;
  p = 0;

  fseek(index,0,2);
  ta = ftell(index);
   // tamanho do indice

  fseek(index,0,0);
  while(ta > p){
   // enquanto p menor que indice
    preenche(index,i);
       // recupera o isbn e salva em i
    fread(&t,4,1,index);
       // le o offset do isbn
    if(strcmp(i,ib) == 0){
       // caso seja o isbn procurado
     return t;
       // retorna o offset do isbn
     getche();
   }
   p = p + 18;
       // incrementa ponteiro do indice
 }
 return 0;
    // caso nao encontre retorna 0
}

/* Funcao para percorrer o indice e exibir seus valores */
void leIndex(){
  char i[14];
  int t,p,ta;
  p = 0;

  fseek(index,0,2);
  ta = ftell(index);
   // tamanho do indice
  fseek(index,0,0);
  while(ta > p){
   // enquanto p menor que indice
    preenche(index,i);
       // recupera o isbn e salva em i
    fread(&t,4,1,index);
       // le o offset do isbn
    printf("\nISBN: %s | POS: %d",i,t);
       // imprime os valores de ISBN e Posicao
    p = p + 18;
       // incrementa ponteiro do indice
    getche();
  }

}

/*Função menu: exibe o menu com as opções do programa.*/
int menu(void){
  int i,h,pos,r;

  while (i!=99){
    // 99 = sair do laco
   system("cls");
   printf("MENU\n");
   printf("\n1 - Inserir livro");
   printf("\n2 - Insercao otimizada");
   printf("\n3 - Buscar livro");
   printf("\n4 - Buscar livro pelo index");
   printf("\n5 - Editar livro");
   printf("\n6 - Deletar livro");
   printf("\n7 - Compactar arquivo");
   printf("\n8 - Ver Header");
   printf("\n9 - Percorrer lista de espacos vagos");
   printf("\n10 - Gerar Index");
   printf("\n11 - Percorre Index");

   printf("\n\n99 - Sair");
   printf("\n\nDigite a opcao: ");
   scanf("%d",&i);

   switch(i){
    case 1:
            // inserir
    system("cls");
    fflush(stdin);
    printf("ISBN (13 digitos): ");
    gets(isbn);
    while(strlen(isbn) != 13){
          // enquanto o ISBN nao for = 13
      printf("Informe o ISBN com 13 caracteres!\n");
      printf("ISBN (13 digitos): ");
      gets(isbn);
      system("cls");
    }
    printf("Titulo: ");
    gets(titulo);
    printf("Autor: ");
    gets(autor);
    printf("Ano: ");
    gets(ano);
    tam = 0;
    fseek(out,0,2);
                // para inserir no final do arq.
    inserir();
        // chama funcao inserir
    break;
    case 2:
            //inserir otimizado
    system("cls");
    fflush(stdin);
    printf("ISBN (13 digitos): ");
    gets(isbn);
    while(strlen(isbn) != 13){
      printf("Informe o ISBN com 13 caracteres!\n");
      printf("ISBN (13 digitos): ");
      gets(isbn);
      system("cls");
    }
    printf("Titulo: ");
    gets(titulo);
    printf("Autor: ");
    gets(autor);
    printf("Ano: ");
    gets(ano);
    tam = 0;
    inserir_o();
    break;
    case 3:
      // Busca de livro
    printf("\nDigite o numero do ISBN desejado:\n");
    scanf("%s",isbn_busca);
    pesquisaisbn();
        // chama funcao de busca ISBN
    break;
    case 4:
      // Busca livro pelo indece
    printf("\nDigite o numero do ISBN desejado:\n");
    scanf("%s",isbn_busca);
    r = buscaIndex(isbn_busca);
        // recebe o offset do isbn
    if(r != 0){
     fseek(out,r+4,0);
                 // seek para o isbn do registro
     system("cls");
     preenche(out,isbn);
                 // recupera e exibe dados do registro
     printf("ISBN: %s",isbn);
     preenche(out,titulo);
     printf("\nTitulo: %s",titulo);
     preenche(out,autor);
     printf("\nAutor: %s",autor);
     preenche(out,ano);
     printf("\nAno: %s",ano);
   }else{
    printf("ISBN nao encontrado!");
  }
  getche();
  break;
  case 5:
            // alterar registro
  printf("\nDigite o ISBN do livro a ser alterado:\n");
  scanf("%s",isbn_busca);
  while (pesquisaisbn()==0){
    printf("\nDigite o ISBN do livro a ser alterado:\n");
    scanf("%s",isbn_busca);
  }
  edit = 1;
                 // seta flag para saber que é a funcao editar
  editar();
                 // que ira chamar internamenta a deletar* e inserir
  printf("Registro editado com sucesso!");
  getche();
  edit = 0;
  break;
  case 6:
            // deletar registro
  printf("\nDigite o ISBN do livro a ser deletado:\n");
  scanf("%s",isbn_busca);
  while (pesquisaisbn()==0){
    printf("\nDigite o ISBN do livro a ser deletado:\n");
    scanf("%s",isbn_busca);
  }
  deletar();
  break;
  case 7:
      // compactar registro
  compacta();
  break;
  case 8:
      // Exibe o Header do arquivo
  fseek(out,0,0);
  fread(&h,4,1,out);
  printf("Header: %d",h);
  getche();
  break;
  case 9:
        // Percorre a Lista de registros deletados
  fseek(out,0,0);
  fread(&pos,4,1,out);
  while(pos != -1){
    fseek(out,pos,0);
    printf("\nPos: %d",pos);
    getche();
    fseek(out,5,1);
    fread(&pos,4,1,out);
  }
  printf("\nPos: %d",pos);
  getche();
  break;
  case 10:
        // Gera o indice
  geraIndex();
  printf("\nIndice gerado com sucesso!");
  getche();
  break;
  case 11:
        // Percorre o indice e exibe os resultados
  leIndex();
  printf("\nfim do index");
  getche();
  break;
}
}
}

int main(void){
	int headerI = -1;
  // valor do Header inicial
 if ((out = fopen("arquivo.bin","r+b")) == NULL){
  printf("Nao foi possivel abrir o arquivo atual, gerando novo arquivo...");
  out = fopen("arquivo.bin","w+b");
  index = fopen("index.bin","w+b");
  fwrite(&headerI,sizeof(headerI),1,out);
    // salva valor inicial do header
  getche();
}

index = fopen("index.bin","r+b");
   // toda vez que abrir o programa é regerado o indice
geraIndex();
printf("\nIndice gerado com sucesso!");

menu();
   // chama o menu principal
fclose(out);
   // fecha os arquivos
fclose(index);
return 0;
}
