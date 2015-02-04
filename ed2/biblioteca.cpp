/*
Autores: David Asbahr Pedoneze | Juliana F. Saito
Versao do compilador: Dev-C++ 4.9.9.2
*/

#include <ctype.h>
#include <stdio.h>
#include <stdlib.h>
#include <conio.h>
#include <string.h>
#include <time.h>

#define maxlenght 20
#define ordem 4
#define dhs 12

int opn = 0;
int RRN = -1;
   // Salva o ultimo rrn utilizado no arquivo de dados
int ROOT = -1;
   // Salva a raiz da arvore

int promovido,
   // Utilizados pelas funções de manipulação da arvore-b
rrnPromovido,
rrnEncontrado,
rrnPos,
addrEncontrado,
encontrado,
addr,
addrPromovido,
chave,
chavePromovida;

typedef struct{
 int   page,
   // Ultimo RRN Utilizado
         root,			// Raiz da arvore
         RRNdel;
         //RRN Deletado (-1 = nada deletado)
       }fheader;
   //total sizeof(fheader)

       typedef struct{
         int contaChave;
         int chave[ordem-1],
         addr[ordem-1],
       // RRN's das entradas no arquivo de dados
         rrn[ordem],
         num;
       // Somente para registrar o RRN da pagina na arvore
       }bTree;

       typedef struct{
//    Conta com uma chave/ponteiro a mais, para ser
         int contaChave;
   // utilizada no split.
         int chave[ordem];
         int  addr[ordem],
         rrn[ordem+1],
         num;
       }temp;

       struct dados {
        char disp;
        char isbn[13];
        char titulo[50];
        char autor[13];
        char ano[4];
 };				//total sizeof(dados)

 int ultimoRrn,
 raiz;

 FILE *arq;
 FILE *btree;
 FILE *aux1;
 FILE *aux2;


////////////////////////////////////////////////////////////////////////////////
// Declarações das funções
////////////////////////////////////////////////////////////////////////////////

// Funções de abertura/fechamento de arquivos
 fheader file_open (FILE **data, char nome[]);
 void file_close (FILE **data, int page, int root);

// Funções de manipulação do arquivo de dados
 dados entry_init(dados entry);
 dados entry_get ();
 int entry_add (FILE **data, dados entry, int RRN);
 void entry_search (FILE **data, int RRN);

// Funções de manipulação da arvore-B
 void Bubblesort (int v[],int n,int b[], int a[]);
 void inicPagina(bTree *pagina);
 void lePagina(int rrn,bTree* pagina,FILE* fp);
 void criaArvore(FILE* fp);
 void imprime(int rrn,FILE *fp);
 void split(int i_key,int i_rrn, int i_addr,int *rrnPromovido,int *chavePromovida,int *addrPromovido,bTree *pagina,bTree *novaPagina);
 int criaRaiz(int chavePromovida, int addrPromovido, int rrnAtual,int rrnPromovido,FILE *fp);
 int inserir(int rrnAtual,int chave, int addr, int *rrnPromovido,int *chavePromovida,int *addrPromovido,FILE *fp);

// Funções de busca na arvore-b
 int busca(int rrn, int chave, int *rrn_encontrado, int *rrn_posicao, int *addr_encontrado, FILE *fp);
////////////////////////////////////////////////////////////////////////////////


////////////////////////////////////////////////////////////////////////////////
// Abre / Cria o arquivo, altera o header.
// Valor de 'page' = -2  significa que houve erro na criação do arquivo.
 fheader file_open (FILE **data, char nome[]){
  fheader header;

  *data = fopen(nome,"r+b");
  if (*data == NULL){
  // Arquivo inexistente - cria novo arquivo
   printf ("Arquivo inexistente, criando novo arquivo.");
   if (nome == "dados.txt")
   {
     *data = fopen (nome,"w+b");
     header.page = 0;
     header.root = 0;
     header.RRNdel = -1;
     fwrite(&header,sizeof(fheader),1,*data);
   }
   else if (nome == "arvore.txt")
   {
     *data = fopen (nome,"w+b");
     header.page = 0;
     header.root = 0;
     header.RRNdel = -1;
     fwrite(&header,sizeof(fheader),1,*data);

     ultimoRrn = header.page;
     raiz = header.root;
     criaArvore(btree);
   }
   else
   {
     printf ("\n\n * ERRO: Impossivel determinar cabecalho para '%s'.",nome);
     header.page = -2;
   }
 }
 else {
  // Arquivo já existe - altera cabeçalho
   fread(&header,sizeof(fheader),1,*data);
   printf("Arquivo aberto com sucesso.");
   fseek(*data,0,0);
   fwrite(&header,sizeof(fheader),1,*data);

 }
 return (header);
};


////////////////////////////////////////////////////////////////////////////////
// Remove um dado
int remover_cadastro (FILE *data, int pos){


   //dados cad;
 int tamanho = 0;
 int BFS = 0;
 int current;
 int i = -1;
 int minusOne = -1;
 int next;
 int isbn2;
 fheader cab;

 fseek(data,0,0);
 fread(&cab,sizeof(fheader),1,data);

 if (cab.RRNdel == -1){

  fseek(data,0,0);
  cab.RRNdel = (pos-sizeof(fheader))/sizeof(dados);
  fwrite(&cab,sizeof(fheader),1,data);
  fseek(data,pos,0);
  fputc('*',data);
  fwrite(&minusOne, sizeof(int), 1, data);

}else{
 fseek(data,pos,0);
 pos = (pos-sizeof(fheader))/sizeof(dados);
 fputc('*',data);
 fwrite(&minusOne,sizeof(int), 1, data);
 next = cab.RRNdel;
 while(next != -1){
   fseek(data,next*sizeof(dados)+sizeof(fheader)+1,0);
   fread(&next, sizeof(int), 1, data);
 }
 fseek(data, -sizeof(int), 1);
 fwrite(&pos, sizeof(int), 1, data);


}
};


////////////////////////////////////////////////////////////////////////////////
// Imprime uma entrada na tela
void entry_print (dados entry){
 printf("\n\n > ISBN: %s\n",entry.isbn);
 printf(" > Titulo: %s\n",entry.titulo);
 printf(" > Autor: %s\n",entry.autor);
 printf(" > Ano: %s\n",entry.ano);

 if(opn == 2){

   printf("Deseja remover? (SIM - 1 | NAO - 2)");
   scanf("%d",&opn);


   if(opn == 1){

           //remover
    int pos;
    fseek(arq,-sizeof(dados),1);
    printf("removido");
    pos = ftell(arq);
    remover_cadastro(arq,pos);
  }

}
}


////////////////////////////////////////////////////////////////////////////////
// Incializa a struct
dados entry_init(dados entry){

 for(int i = 0; i < 13; i++){
  entry.isbn[i] = '\0';
}

for(int i = 0; i < 4; i++){
  entry.ano[i] = '\0';
}

for(int i = 0; i < 50; i++){
  entry.titulo[i] = '\0';
}

for(int i = 0; i < 13; i++){
  entry.autor[i] = '\0';
}

return(entry);
}


////////////////////////////////////////////////////////////////////////////////
// Carrega dados em uma entrada
dados entry_get (){
 dados entry;
 entry = entry_init(entry);

 printf("\n\n > ISBN: ");
 scanf("%s",&entry.isbn);
 fflush(stdin);
 printf("\n > Titulo: ");
 gets(entry.titulo);
   //scanf("%s",&entry.titulo);
 fflush(stdin);
 printf("\n > Autor: ");
 gets(entry.autor);
   //scanf("%s",&entry.autor);
 fflush(stdin);
 printf("\n > ano: ");
 scanf ("%s",&entry.ano);
 fflush(stdin);
 entry.disp = '!';

 entry_print(entry);
 return (entry);
}


////////////////////////////////////////////////////////////////////////////////
// Insere entradas no arquivo de dados, retorna o proximo RRN livre
int entry_add (FILE **data, dados entry, int RRN){

 fheader cabecalho;
 int offset=0, offsetOld,rrnatual,menosum;

 fseek(*data,0,0);
 fread(&cabecalho,sizeof(fheader),1,*data);

 if(cabecalho.RRNdel == -1){

  int pos = sizeof(fheader);
  pos += RRN*sizeof(dados);
  fseek (*data,pos,0);
  fwrite(&entry,sizeof(dados),1,*data);
  RRN++;
  return(RRN);

}else{
  offset = cabecalho.RRNdel*sizeof(dados)+sizeof(fheader)+1;
  fseek(*data,offset,0);
  fread(&rrnatual,4,1,*data);
  while(rrnatual != -1){
   offsetOld = offset;
   fseek(*data,rrnatual*sizeof(dados)+sizeof(fheader)+1,0);
   fread(&rrnatual,4,1,*data);
   if(rrnatual == -1){
    fseek(*data,-5,1);
    fwrite(&entry,sizeof(dados),1,*data);
    RRN++;
    fseek(*data,offsetOld,0);
    menosum = -1;
    fwrite(&menosum,4,1,*data);

    return(RRN);
  }else{
    offset = rrnatual*sizeof(dados)+sizeof(fheader)+1;
  }

}

}
}


////////////////////////////////////////////////////////////////////////////////
// Le uma entrada, baseado no seu RRN
void entry_search (FILE **data, int RRN){
 dados entry;
 int pos = sizeof(fheader);
 pos += RRN*sizeof(dados);
 fseek(*data,pos,0);
 fread(&entry,sizeof(dados),1,*data);
 entry_print(entry);
}





////////////////////////////////////////////////////////////////////////////////
// Compactar
void compactar()
{
 fheader header;
 int inicial;
 char excluido;
 dados copiador;


     //abrir arquivo auxiliar
 FILE *auxiliar = fopen("auxiliar.txt", "w+b");
 header.page = 0;
 header.root = 0;
 header.RRNdel = -1;
 fwrite(&header,sizeof(fheader),1,auxiliar);

     //--------------------

 system("cls");
 fseek(arq, sizeof(fheader), 0);
 excluido = getc(arq);

 fclose(btree);
 remove("arvore.txt");
 FILE *btree = fopen("arvore.txt","w+b");
 header.page = 0;
 header.root = 0;
 header.RRNdel = -1;
 fwrite(&header,sizeof(fheader),1,btree);


 while(excluido != EOF) {
   if (excluido == '*') {
    fseek(arq, sizeof(dados)-1, 1);
    excluido = getc(arq);
  } else {
   fseek(arq, -1, 1);
   fread(&copiador, sizeof(dados), 1, arq);

   RRN = -1;
   ROOT = -1;
   RRN = entry_add(&auxiliar,copiador,RRN);
   getch();

             // Insere indice na arvore-b
   int isbn1;
   isbn1 = atoi(copiador.isbn);
   promovido = inserir(raiz,isbn1,(RRN-1),&rrnPromovido,&chavePromovida,&addrPromovido,btree);
   if(promovido==1){
    printf("\n * Raiz promovida");
    criaRaiz(chavePromovida, addrPromovido,raiz,rrnPromovido,btree);
  }

  excluido = getc(arq);
}
}

fclose(arq);
fclose(auxiliar);
remove("dados.txt");
inicial = rename("auxiliar.txt", "dados.txt");
arq = fopen("dados.txt", "r+b");

printf("\n\nCompactacao efetuada com sucesso.");

getche();

}

//****************************************************************************//
//                     Rotinas de manipulação da arvore-b
//
//****************************************************************************//

////////////////////////////////////////////////////////////////////////////////
// Ordena chaves, rrns e ponteiros dentro das páginas
void Bubblesort (int v[],int n,int b[], int a[]) {
 int i,j;
 char tmp,tmp1;
 int auxAddr;

 for (i=0; i<n-1; i++) {
   for (j=0; j<n-i-1; j++)
    if (v[j] > v[j+1]) {
     tmp = v[j];
     auxAddr = a[j];
     tmp1=b[j+1];
     v[j] = v[j+1];
     a[j] = a[j+1];
     b[j+1]=b[j+2];
     v[j+1] = tmp;
     a[j+1] = auxAddr;
     b[j+2]=tmp1;
   }
 }
}


////////////////////////////////////////////////////////////////////////////////
// Inicializa paginas da arvore com os valores default
void inicPagina(bTree *pagina){
  int i=0;
  while (i<3){
   pagina->chave[i]=0;
   pagina->addr[i]=0;
   pagina->rrn[i]=-1;
   i++;
 }
 pagina->rrn[3]=-1;
 pagina->contaChave=0;
 pagina->num=0;

}


////////////////////////////////////////////////////////////////////////////////
// Carrega uma pagina da arvore para a memória principal
void lePagina(int rrn,bTree* pagina,FILE* fp){
  int pos = sizeof(fheader);
  pos +=(rrn*sizeof(bTree));
  fseek(fp,pos,0);


  fread(&pagina->num,sizeof(pagina->num),1,fp);
  fread(&pagina->contaChave,sizeof(pagina->contaChave),1,fp);
  fread(&pagina->chave,sizeof(pagina->chave),1,fp);
  fread(&pagina->addr,sizeof(pagina->addr),1,fp);
   //INDEX
  fread(&pagina->rrn,sizeof(pagina->rrn),1,fp);

}


////////////////////////////////////////////////////////////////////////////////
//   Utilizada pela função de criação do arquivo, insere uma pagina inicializada
// e vazia no arquivo para que a função 'insere' funcione corretamente.
void criaArvore(FILE* fp){
  bTree pagina;
  fseek(fp,sizeof(fheader),0);
  inicPagina(&pagina);
  fwrite(&pagina.num,sizeof(pagina.num),1,fp);
  fwrite(&pagina.contaChave,sizeof(pagina.contaChave),1,fp);
  fwrite(&pagina.chave,sizeof(pagina.chave),1,fp);
  fwrite(&pagina.addr,sizeof(pagina.addr),1,fp);
  fwrite(&pagina.rrn,sizeof(pagina.rrn),1,fp);

  printf ("\n * Raiz inserida, arvore criada.\n");
}


////////////////////////////////////////////////////////////////////////////////
// Gerencia a divisão de nós, caso ocorra um overflow em algum nó existente.
void split(int i_key,int i_rrn, int i_addr,int *rrnPromovido,int *chavePromovida,int *addrPromovido,bTree *pagina,bTree *novaPagina){
  int i=0;
  ultimoRrn++;
  temp tempPagina;
  int num;
  printf("\n * Divisao de no.");


     // Copia os dados para uma pagina temporaria, que suporta uma chave a mais
  tempPagina.contaChave=pagina->contaChave;
  while(i<3){
    tempPagina.chave[i]=pagina->chave[i];
    tempPagina.addr[i] = pagina->addr[i];
    tempPagina.rrn[i]=pagina->rrn[i];
    i++;
  }
  tempPagina.rrn[3]=pagina->rrn[3];


     // Insere a chave excedente e ordena a pagina auxiliar
  tempPagina.contaChave++;
  tempPagina.chave[3]=i_key;
  tempPagina.addr[3] = i_addr;
  tempPagina.rrn[4]=i_rrn;
  Bubblesort(tempPagina.chave,4,tempPagina.rrn,tempPagina.addr);

  (*chavePromovida)=tempPagina.chave[2];
  (*addrPromovido) = tempPagina.addr[2];

  num=pagina->num;
     inicPagina(pagina);// Valores default para as paginas
     inicPagina(novaPagina);


   // Coloca chaves na pagina antiga sem o promovido
     pagina->num=num;
     pagina->contaChave=2;
     pagina->chave[0]=tempPagina.chave[0];
     pagina->chave[1]=tempPagina.chave[1];
     pagina->addr[0]=tempPagina.addr[0];
     pagina->addr[1]=tempPagina.addr[1];
     pagina->rrn[0]=tempPagina.rrn[0];
     pagina->rrn[1]=tempPagina.rrn[1];
     pagina->rrn[2]=tempPagina.rrn[2];


   // Coloca chaves em nova pagina
     novaPagina->num=ultimoRrn;
     novaPagina->contaChave=1;
     novaPagina->chave[0]=tempPagina.chave[3];
     novaPagina->addr[0] =tempPagina.addr[3];
     novaPagina->rrn[0]=tempPagina.rrn[3];
     novaPagina->rrn[1]=tempPagina.rrn[4];

     printf("\n * Chave %d(RRN:%d) promovida.",*chavePromovida,*addrPromovido);


     // RRN promovido aponta para nova pagina
     (*rrnPromovido)=novaPagina->num;
   }



////////////////////////////////////////////////////////////////////////////////
// Cria um novo nó raiz quando o anterior sofreu um split
   int criaRaiz(int chavePromovida, int addrPromovido, int rrnAtual,int rrnPromovido,FILE *fp){
     bTree pagina;
     int rrn;
     ultimoRrn++;
     inicPagina(&pagina);
     pagina.chave[0]=chavePromovida;
     pagina.addr[0] =addrPromovido;
     pagina.rrn[0]=rrnAtual;
     pagina.rrn[1]=rrnPromovido;
     pagina.contaChave=1;
     fseek(fp,sizeof(fheader)+(ultimoRrn*sizeof(bTree)),0);
     raiz=ultimoRrn;
     pagina.num=raiz;
     fwrite(&pagina.num,sizeof(pagina.num),1,fp);
     fwrite(&pagina.contaChave,sizeof(pagina.contaChave),1,fp);
     fwrite(&pagina.chave,sizeof(pagina.chave),1,fp);
     fwrite(&pagina.addr,sizeof(pagina.addr),1,fp);
    //INDEX
     fwrite(&pagina.rrn,sizeof(pagina.rrn),1,fp);
     printf("\n * Nova raiz criada.");

   }


////////////////////////////////////////////////////////////////////////////////
// Gerencia a inserção de novas chaves
   int inserir(int rrnAtual,int chave, int addr, int *rrnPromovido,int *chavePromovida,int *addrPromovido,FILE *fp){
     bTree pagina;
     bTree novaPagina;

     int promovida=0;
  // Retorna 1 caso ocorra promoção
     int i=0;
     int pos,
     posArq;
     int valor;
     int p_b_rrn,
     p_b_addr,
     p_b_chave;


     if (rrnAtual==-1){
      (*chavePromovida)=chave;
      (*addrPromovido)=addr;
      (*rrnPromovido)=-1;
      promovida=1;
      return (promovida);
    }
    else{
     inicPagina(&pagina);
     lePagina(rrnAtual,&pagina,fp);
     if(chave!=pagina.chave[0] && chave!=pagina.chave[1] && chave!=pagina.chave[2]){
       if(chave<pagina.chave[0] || pagina.contaChave==0)
        pos=0;
      else if(chave>pagina.chave[0] && (chave<pagina.chave[1] || pagina.contaChave==1))
        pos=1;
      else if(chave>pagina.chave[1] && (chave<pagina.chave[2] || pagina.contaChave==2))
        pos=2;
      else if(chave>pagina.chave[2])
        pos=3;
    }
    else
      pos=-2;
  }
  if(pos==-2){
    printf("\n > ERRO: Arvore-B (A chave a ser inserida ja existe).");
    return (0);
  }
  valor=inserir(pagina.rrn[pos],chave,addr,&p_b_rrn,&p_b_chave,&p_b_addr,fp);
  if(valor==0)
    return (0);
  else if(pagina.contaChave<3){


        // Adiciona a nova chave na posição correta da pagina
   pagina.chave[pagina.contaChave]=p_b_chave;
   pagina.addr[pagina.contaChave]=p_b_addr;
      //INDEX
   pagina.rrn[pagina.contaChave+1]=p_b_rrn;
   pagina.contaChave++;
   promovida=0;

   		// Ordena pagina
   Bubblesort(pagina.chave,pagina.contaChave,pagina.rrn,pagina.addr);
   fseek(fp,sizeof(fheader)+(sizeof(bTree)*pagina.num),0);
   posArq=ftell(fp);


        // Grava pagina no arquivo
   fwrite(&pagina.num,sizeof(pagina.num),1,fp);
   fwrite(&pagina.contaChave,sizeof(pagina.contaChave),1,fp);
   fwrite(&pagina.chave,sizeof(pagina.chave),1,fp);
   fwrite(&pagina.addr,sizeof(pagina.addr),1,fp);
   fwrite(&pagina.rrn,sizeof(pagina.rrn),1,fp);
   printf("\n * Chave '%d' inserida.\n",chave);
   return promovida;
 }
 else{
   split(p_b_chave,p_b_rrn,p_b_addr,rrnPromovido,chavePromovida,addrPromovido,&pagina,&novaPagina);

   fseek(fp,sizeof(fheader)+(sizeof(bTree)*pagina.num),0);
   fwrite(&pagina.num,sizeof(pagina.num),1,fp);
   fwrite(&pagina.contaChave,sizeof(pagina.contaChave),1,fp);
   fwrite(&pagina.chave,sizeof(pagina.chave),1,fp);
   fwrite(&pagina.addr,sizeof(pagina.addr),1,fp);
   fwrite(&pagina.rrn,sizeof(pagina.rrn),1,fp);

   fseek(fp,sizeof(fheader)+(ultimoRrn*sizeof(bTree)),0);

   fwrite(&novaPagina.num,sizeof(novaPagina.num),1,fp);
   fwrite(&novaPagina.contaChave,sizeof(novaPagina.contaChave),1,fp);
   fwrite(&novaPagina.chave,sizeof(novaPagina.chave),1,fp);
   fwrite(&novaPagina.addr,sizeof(novaPagina.addr),1,fp);
   fwrite(&novaPagina.rrn,sizeof(novaPagina.rrn),1,fp);
   promovida=1;
   return (promovida);
 }
}


////////////////////////////////////////////////////////////////////////////////
// Busca por uma determinada chave na arvore
int busca(int rrn, int chave, int *rrn_encontrado, int *rrn_posicao, int *addr_encontrado, FILE *fp){
 bTree pagina;
 int pos, valor;
 if (rrn == -1){
  return 0;
}else{
 lePagina(rrn,&pagina,fp);

 if(chave<pagina.chave[0] || pagina.contaChave==0 || chave==pagina.chave[0])
  pos=0;
else if((chave>pagina.chave[0] && (chave<pagina.chave[1] || pagina.contaChave==1)) || chave==pagina.chave[1])
  pos=1;
else if((chave>pagina.chave[1] && (chave<pagina.chave[2] || pagina.contaChave==2)) || chave==pagina.chave[2])
  pos=2;
else if(chave>pagina.chave[2])
  pos=3;


     // Verifica se a chave foi encontrada
if( (chave == pagina.chave[0]) || (chave == pagina.chave[1]) || (chave == pagina.chave[2])){
 *rrn_encontrado= rrn;
 *rrn_posicao= pos;
 *addr_encontrado = pagina.addr[pos];
 printf("\n * ISBN %d encontrado, pagina %d,posicao %d.",chave,*rrn_encontrado,*rrn_posicao);
 getch();
 return 1;
}else{
 valor = busca(pagina.rrn[pos], chave, rrn_encontrado, rrn_posicao, addr_encontrado, fp);
 return valor;
}
}
}











////////////////////////////////////////////////////////////////////////////////
// MENU PRINCIPAL
int main (void){

 int sair = 0;
   // Sair / Recarregar menu
 int aux = 0;
   // Uso geral
 fheader header;
   // Cabeçalho de uso geral
 dados entry;
   // Cadastro de uso geral

// Abertura / Carregamento dos arquivos-----------------------------------------

 printf ("\n > Arquivo de dados: ");
 header = file_open(&arq,"dados.txt");
 RRN = header.page;

 printf ("\n\n > Arquivo  de  indices primarios: ");
 header = file_open(&btree,"arvore.txt");
 ultimoRrn = header.page;
 raiz = header.root;

 getch();

// Menu Principal---------------------------------------------------------------
 while (!sair)
 {

  printf ("\n\n   1- Adicionar entrada\n");
  printf ("   2- Pesquisa (Chave Primaria)\n");
  printf ("   3- Pesquisa (Chave Secundaria)\n");
  printf ("   4- Compactar\n");
  printf ("   0- Sair\n");
  printf ("\n   Opcao: ");
  fflush (stdin);
  scanf ("%d",&opn);

  switch (opn)
  {
   case 1 :
       //inserir dados

             // Insere no arquivo de dados
   entry = entry_get();
   RRN = entry_add(&arq,entry,RRN);
   getch();

             // Insere indice na arvore-b
   int isbn1;
   isbn1 = atoi(entry.isbn);
   promovido = inserir(raiz,isbn1,(RRN-1),&rrnPromovido,&chavePromovida,&addrPromovido,btree);
   if(promovido==1){
    printf("\n * Raiz promovida");
    criaRaiz(chavePromovida, addrPromovido,raiz,rrnPromovido,btree);

  }
  getch();
  break;
  case 2 :
  char isbn2[13];
  printf("\n\n > Buscar isbn: ");
  fflush(stdin);
  scanf("%s",&isbn2);
  chave = atoi(isbn2);
  encontrado=busca(raiz,chave,&rrnEncontrado,&rrnPos, &addrEncontrado, btree);
  if(encontrado==0)
  {
   printf("\n * Chave '%d' nao encontrada",chave);
 }
 else
 {
   entry_search(&arq,addrEncontrado);
 }
 getch();
 break;
    /*  case 3 :
             pesquisa por chave secundária
             getch(); */
             case 4:
             compactar();
             break;
             case 0 :
             sair = 1;
             fclose(arq);
             fclose(btree);
             break;
             default :
             printf("\n > Opcao invalida!");
             getch();
           }
         }
       }
