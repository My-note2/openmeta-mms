/* BDD library print routines */


#include "bddint.h"
#include <tchar.h>


static
void
#if defined(__STDC__)
chars(TCHAR c, int n, FILE *fp)
#else
chars(c, n, fp)
     TCHAR c;
     int n;
     FILE *fp;
#endif
{
  int i;

  for (i=0; i < n; ++i)
    fputc(c, fp);
}


static
void
#if defined(__STDC__)
bdd_print_top_var(bdd_manager bddm,
		  bdd f,
		  TCHAR *(*var_naming_fn)(bdd_manager, bdd, pointer),
		  pointer env,
		  FILE *fp)
#else
bdd_print_top_var(bddm, f, var_naming_fn, env, fp)
     bdd_manager bddm;
     bdd f;
     TCHAR *(*var_naming_fn)();
     pointer env;
     FILE *fp;
#endif
{
  BDD_SETUP(f);
  _fputts(bdd_var_name(bddm, BDD_IF(bddm, f), var_naming_fn, env), fp);
  fputc('\n', fp);
}


static
void
#if defined(__STDC__)
bdd_print_bdd_step(bdd_manager bddm,
		   bdd f,
		   TCHAR *(*var_naming_fn)(bdd_manager, bdd, pointer),
		   TCHAR *(*terminal_id_fn)(bdd_manager, INT_PTR, INT_PTR, pointer),
		   pointer env,
		   FILE *fp,
		   hash_table h,
		   int indentation)
#else
bdd_print_bdd_step(bddm, f, var_naming_fn, terminal_id_fn, env, fp, h, indentation)
     bdd_manager bddm;
     bdd f;
     TCHAR *(*var_naming_fn)();
     TCHAR *(*terminal_id_fn)();
     pointer env;
     FILE *fp;
     hash_table h;
     int indentation;
#endif
{
  int negated;
  long *number;

  BDD_SETUP(f);
  chars(' ', indentation, fp);
  switch (bdd_type_aux(bddm, f))
    {
    case BDD_TYPE_ZERO:
    case BDD_TYPE_ONE:
    case BDD_TYPE_CONSTANT:
      _fputts(bdd_terminal_id(bddm, f, terminal_id_fn, env), fp);
      fputc('\n', fp);
      break;
    case BDD_TYPE_NEGVAR:
      fputc('!', fp);
      /* fall through */
    case BDD_TYPE_POSVAR:
      bdd_print_top_var(bddm, f, var_naming_fn, env, fp);
      break;
    case BDD_TYPE_NONTERMINAL:
      if (bdd_lookup_in_hash_table(h, BDD_NOT(f)))
	{
	  f=BDD_NOT(f);
	  negated=1;
	}
      else
	negated=0;
      number=(long *)bdd_lookup_in_hash_table(h, f);
      if (number && *number < 0)
	{
	  if (negated)
	    fputc('!', fp);
	  fprintf(fp, "subformula %d\n", -*number-1);
	}
      else
	{
	  if (number)
	    {
	      fprintf(fp, "%d: ", *number);
	      *number= -*number-1;
	    }
	  fputs("if ", fp);
	  bdd_print_top_var(bddm, f, var_naming_fn, env, fp);
	  bdd_print_bdd_step(bddm, BDD_THEN(f), var_naming_fn, terminal_id_fn, env, fp, h, indentation+2);
	  chars(' ', indentation, fp);
	  fputs("else if !", fp);
	  bdd_print_top_var(bddm, f, var_naming_fn, env, fp);
	  bdd_print_bdd_step(bddm, BDD_ELSE(f), var_naming_fn, terminal_id_fn, env, fp, h, indentation+2);
	  chars(' ', indentation, fp);
	  fputs("endif ", fp);
	  bdd_print_top_var(bddm, f, var_naming_fn, env, fp);
	}
      break;
    default:
      bdd_fatal(_T("bdd_print_bdd_step: unknown type returned by bdd_type"));
    }
}


/* bdd_print_bdd(bddm, f, var_naming_fn, terminal_id_fn, env, fp) prints a */
/* human-readable representation of f to the file given by fp.  If */
/* var_naming_fn is non-null, it should be a pointer to a function that */
/* assigns names to BDD variables.  It is passed bddm, a BDD representing */
/* a variable, and the pointer given by env, and should return a string */
/* giving the name of the variable or null.  If terminal_id_fn is */
/* non-null, it should be a pointer to a function that formats terminal */
/* nodes.  It is passed bddm, two longs representing the data value of */
/* the terminal node, and env.  It should return a string for the */
/* terminal node, or null. */

void
#if defined(__STDC__)
bdd_print_bdd(bdd_manager bddm,
	      bdd f,
	      TCHAR *(*var_naming_fn)(bdd_manager, bdd, pointer),
	      TCHAR *(*terminal_id_fn)(bdd_manager, INT_PTR, INT_PTR, pointer),
	      pointer env,
	      FILE *fp)
#else
bdd_print_bdd(bddm, f, var_naming_fn, terminal_id_fn, env, fp)
     bdd_manager bddm;
     bdd f;
     TCHAR *(*var_naming_fn)();
     TCHAR *(*terminal_id_fn)();
     pointer env;
     FILE *fp;
#endif
{
  long next;
  hash_table h;

  if (!bdd_check_arguments(1, f))
    {
      fprintf(fp, "overflow\n");
      return;
    }
  bdd_mark_shared_nodes(bddm, f);
  h=bdd_new_hash_table(bddm, sizeof(long));
  next=0;
  bdd_number_shared_nodes(bddm, f, h, &next);
  bdd_print_bdd_step(bddm, f, var_naming_fn, terminal_id_fn, env, fp, h, 0);
  bdd_free_hash_table(h);
}
