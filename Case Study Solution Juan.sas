/*
Programa: Case Study Solutions Juan.sas
Autor: Juan Medeiros
Data: 04/05/2022
Versao:1.00

DescriÁ„o: ResoluÁ„o Case Study SAS Prog 2 - Data Manipulations

*/

data Cleaned_tourism;
	
	/*Definir um Tamanho para Contry Name e Tourism Type*/
	Length Country_Name $ 300  Tourism_Type $ 100;
	set work.tourism(drop=_1995-_2013);
	
	/*Reter os Nomes de pais e tipo de turismo em cada uma das linhas da tabela*/
	retain Country_Name "" Tourism_Type "";
	
	/*Criar a variavel Country_Name e Tourism_type*/
	if A NE . then country_name=Country;
	if Scan(Country,-1) eq "tourism" then Tourism_Type=Country;
	
	/*Apagar a primeira linha de cabe√ßalho de Tourism Type e Country Name*/
	if  Country_name ne Country and  Tourism_type ne Country;
	
	/*Alterar os valores de Series Para apenas 1 Ponto e para Maiusculas*/
	if Series=".." then Series="";
	else Series=Upcase(Series);
	
	/*Criar nossa variavel conversion Type*/
	if scan(Country,-1)="Mn" or scan(Country,-1)="Thousands" then ConversionType=Scan(country,-1);
	
	/*Faz todos os ajustes em _2014 e cria nossa variavel chamado Y2014*/
	if _2014=".." then _2014=".";
	if ConversionType="Mn" then Y2014=input(_2014,16.)*1000000;
	else Y2014=input(_2014,16.)*1000;
	
	/*Cria nossa variavel Category*/
	if scan(Country,1)="Arrivals" or Scan(Country,1)="Departures" then Category=scan(country,1,"-");
	else Category=substr(Country,1,find(Country,"Mn")-1);
	
	/*Formata e Remove as variaveis nao utilizadas em nossa tabela final*/
	format Y2014 comma25.;
	drop A _2014 Country ConversionType;
run;



/*Cria√ß√£o da nossa proc format para realizar a formata√ß√£o dos valores de continente*/
proc format ;
	value continent 1 = "North America"
		  2 = "South America"
		  3 = "Europe"
		  4 = "Africa"
		  5 = "Asia"
		  6 = "Oceania"
		  7 = "Antarctica";
run;


/*Realiza a ordena√ß√£o e o Merge de nossas tabelas*/

proc sort data=work.country_info out=country_sorted(Rename=(Country=country_name));
	by Country;
run;


data final_tourism
	 nocountryfound;
	merge cleaned_tourism(in=t)
		  country_sorted(in=c);
	by country_name;
	if t=1 and c=1 then output final_tourism;
	else if (t=1 and c=0) and first.country_name=1 then output nocountryfound;
	format continent continent.;
run;
