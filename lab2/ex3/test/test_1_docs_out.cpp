#include<iostream>
#include<cstdio>


/** Maly przyklad programu
 * 
 *  // autor Maciej Gebala
 * 
 */



using namespace std;


//! Komentarz dokumentacyjny \
	   i jego // ciag dalszy\
  /* i dalszy */
int some_function(int a) {
	return a << (1 << 4);
}

/*! Nieco inny komentarz dokumentacyjny 

	// Komentarz w komentarzu		
					
					
   */
int main()
{
  /// Komentarz dokumentacyjny \
  ciag dalszy jednolinijkowego komentarza
  int i = 5;
  
  cout << "Jakis program" << endl; 
  
  
  
  
  
  ///// Komentarz TODO: Sprawdzić jak to jest interpretowane 
  //! i jeszcze inny komentarz */
  cout << "Koniec komentarza */ "<< endl; 
  cout << "Komentarz /* ala */" << endl;
  
  /*! I jeszcze jeden
					**/
  
  /** "Dokumentujemy nasz \" kod"
  
  */
  
   
  cout << "Zabawa \" // \\\\\"ala i kot \\\\" << endl; // abcabcabc "
  cout << "Komentarz // kot " << endl;
  cout << "Pulapka \" \
           // ma \
           /* \\\"ma\" */ \
		   /** doc */\
           \\\\" << endl;
 cout << /*Proba*/"Zabawa \" // ala i kot " << endl;	   
 printf("Zabawa \" // ala i kot ");
}
