/* Basic BDD routines */


#include "bddint.h"
#include <tchar.h>

DESERT_API int bdd_and_step_count=0;

/* bdd_one(bddm) gives the BDD for true. */

bdd
#if defined(__STDC__)
bdd_one(bdd_manager bddm)
#else
bdd_one(bddm)
     bdd_manager bddm;
#endif
{
  return (BDD_ONE(bddm));
}


/* bdd_zero(bddm) gives the BDD for false. */

bdd
#if defined(__STDC__)
bdd_zero(bdd_manager bddm)
#else
bdd_zero(bddm)
     bdd_manager bddm;
#endif
{
  return (BDD_ZERO(bddm));
}


bdd
#if defined(__STDC__)
bdd_make_external(bdd f)
#else
bdd_make_external(f)
     bdd f;
#endif
{
  BDD_SETUP(f);
  BDD_INCREFS(f);
  BDD_TEMP_DECREFS(f);
  return (f);
}


long
#if defined(__STDC__)
bdd_find_block(block b, long index)
#else
bdd_find_block(b, index)
     block b;
     long index;
#endif
{
  long i, j, k;

  i=0;
  j=b->num_children-1;
  while (i <= j)
    {
      k=(i+j)/2;
      if (b->children[k]->first_index <= index && b->children[k]->last_index >= index)
        return (k);
      if (b->children[k]->first_index > index)
        j=k-1;
      else
        i=k+1;
    }
  return (i);
}


void
#if defined(__STDC__)
bdd_block_delta(block b, long delta)
#else
bdd_block_delta(b, delta)
     block b;
     long delta;
#endif
{
  long i;

  b->first_index+=delta;
  b->last_index+=delta;
  for (i=0; i < b->num_children; ++i)
    bdd_block_delta(b->children[i], delta);
}


static
block
#if defined(__STDC__)
shift_block(bdd_manager bddm, block b, long index)
#else
shift_block(bddm, b, index)
     bdd_manager bddm;
     block b;
     long index;
#endif
{
  long i, j;
  block p;

  if (b->first_index >= index)
    {
      bdd_block_delta(b, 1l);
      return (b);
    }
  if (b->last_index < index)
    return (b);
  b->last_index++;
  i=bdd_find_block(b, index);
  if (i == b->num_children || b->children[i]->first_index == index)
    {
      b->children=(block *)mem_resize_block((pointer)b->children, (SIZE_T)(sizeof(block)*(b->num_children+1)));
      for (j=b->num_children-1; j >= i; --j)
        b->children[j+1]=shift_block(bddm, b->children[j], index);
      b->num_children++;
      p=(block)BDD_NEW_REC(bddm, sizeof(struct block_));
      p->reorderable=0;
      p->first_index=index;
      p->last_index=index;
      p->num_children=0;
      p->children=0;
      b->children[i]=p;
    }
  else
    while (i < b->num_children)
      {
        shift_block(bddm, b->children[i], index);
        ++i;
      }
  return (b);
}


/* bdd_new_var(bddm, index) creates a new variable with the */
/* specified index.  Existing variables with greater or equal index */
/* have their index incremented. */

static
bdd
#if defined(__STDC__)
bdd_new_var(bdd_manager bddm, bdd_index_type index)
#else
bdd_new_var(bddm, index)
     bdd_manager bddm;
     bdd_index_type index;
#endif
{
  long i;
  long temp;
  long oldmax;
  assoc_list p;
  bdd var;

  if (bddm->vars == BDD_MAX_INDEXINDEX)
    bdd_fatal(_T("bdd_new_var: no more indexes"));
  if (index > bddm->vars)
    bdd_fatal(_T("bdd_new_var: index out of range"));
  if (bddm->vars == bddm->maxvars)
    {
      /* Expand indexing tables and variable associations. */
      oldmax=bddm->maxvars;
      temp=bddm->maxvars*2;
      if (temp > BDD_MAX_INDEXINDEX-1)
        temp=BDD_MAX_INDEXINDEX-1;
      bddm->maxvars=temp;
      bddm->variables=(bdd *)mem_resize_block((pointer)bddm->variables,
                                              (SIZE_T)((bddm->maxvars+1)*sizeof(bdd)));
      bddm->indexes=(bdd_index_type *)mem_resize_block((pointer)bddm->indexes,
                                                       (SIZE_T)((bddm->maxvars+1)*sizeof(bdd_index_type)));
      bddm->indexindexes=
        (bdd_indexindex_type *)mem_resize_block((pointer)bddm->indexindexes,
                                                (SIZE_T)(bddm->maxvars*sizeof(bdd_indexindex_type)));
      bddm->unique_table.tables=
        (var_table *)mem_resize_block((pointer)bddm->unique_table.tables,
                                      (SIZE_T)((bddm->maxvars+1)*sizeof(var_table)));
      /* Variable associations are padded with nulls in case new variables */
      /* are created. */
      for (p=bddm->assocs; p; p=p->next)
        {
          p->va.assoc=(bdd *)mem_resize_block((pointer)p->va.assoc, (SIZE_T)((bddm->maxvars+1)*sizeof(bdd)));
          for (i=oldmax; i < bddm->maxvars; ++i)
            p->va.assoc[i+1]=0;
        }
      bddm->temp_assoc.assoc=(bdd *)mem_resize_block((pointer)bddm->temp_assoc.assoc, (SIZE_T)((bddm->maxvars+1)*sizeof(bdd)));
      for (i=oldmax; i < bddm->maxvars; ++i)
        bddm->temp_assoc.assoc[i+1]=0;
    }
  /* Shift index of following variables. */
  if (index != bddm->vars)
    for (i=0; i < bddm->vars; ++i)
      if (bddm->indexes[i+1] >= index)
        bddm->indexes[i+1]++;
  for (p=bddm->assocs; p; p=p->next)
    if (p->va.last >= index)
      p->va.last++;
  if (bddm->temp_assoc.last >= index)
    bddm->temp_assoc.last++;
  /* Shift indexindex values. */
  for (i=bddm->vars; i > index; --i)
    bddm->indexindexes[i]=bddm->indexindexes[i-1];
  /* Make a new variable table. */
  bddm->vars++;
  bddm->unique_table.tables[bddm->vars]=bdd_new_var_table(bddm);
  /* Create the variable. */
  var=bdd_find_aux(bddm, (bdd_indexindex_type)bddm->vars, (INT_PTR)BDD_ONE(bddm), (INT_PTR)BDD_ZERO(bddm));
  var->refs=BDD_MAX_REFS;
  /* Record everything. */
  bddm->variables[bddm->vars]=var;
  bddm->indexes[bddm->vars]=index;
  bddm->indexindexes[index]=bddm->vars;
  /* Make a new variable block containing the variable. */
  shift_block(bddm, bddm->super_block, (long)index);
  return (var);
}


/* bdd_new_var_first(bddm) returns the BDD for a new variable at the */
/* start of the variable order. */

bdd
#if defined(__STDC__)
bdd_new_var_first(bdd_manager bddm)
#else
bdd_new_var_first(bddm)
     bdd_manager bddm;
#endif
{
  return (bdd_new_var(bddm, (bdd_index_type)0));
}


/* bdd_new_var_last(bddm) returns the BDD for a new variable at the */
/* end of the variable order. */

bdd
#if defined(__STDC__)
bdd_new_var_last(bdd_manager bddm)
#else
bdd_new_var_last(bddm)
     bdd_manager bddm;
#endif
{
  return (bdd_new_var(bddm, (bdd_index_type)bddm->vars));
}


/* bdd_new_var_before(bddm, var) returns the BDD for a new variable */
/* before the specified one in the variable order. */

bdd
#if defined(__STDC__)
bdd_new_var_before(bdd_manager bddm, bdd var)
#else
bdd_new_var_before(bddm, var)
     bdd_manager bddm;
     bdd var;
#endif
{
  if (bdd_check_arguments(1, var))
    {
      BDD_SETUP(var);
      if (bdd_type_aux(bddm, var) != BDD_TYPE_POSVAR)
        {
          bdd_warning(_T("bdd_new_var_before: argument is not a positive variable"));
          if (BDD_IS_CONST(var))
            return (bdd_new_var_last(bddm));
        }
      return (bdd_new_var(bddm, BDD_INDEX(bddm, var)));
    }
  return ((bdd)0);
}


/* bdd_new_var_after(bddm, var) returns the BDD for a new variable */
/* after the specified one in the variable order. */

bdd
#if defined(__STDC__)
bdd_new_var_after(bdd_manager bddm, bdd var)
#else
bdd_new_var_after(bddm, var)
     bdd_manager bddm;
     bdd var;
#endif
{
  if (bdd_check_arguments(1, var))
    {
      BDD_SETUP(var);
      if (bdd_type_aux(bddm, var) != BDD_TYPE_POSVAR)
        {
          bdd_warning(_T("bdd_new_var_after: argument is not a positive variable"));
          if (BDD_IS_CONST(var))
            return (bdd_new_var_last(bddm));
        }
      return (bdd_new_var(bddm, BDD_INDEX(bddm, var)+1));
    }
  return ((bdd)0);
}


/* bdd_var_with_index(bddm, index) returns the variable with the */
/* specified index, or null if there is no such variable. */

bdd
#if defined(__STDC__)
bdd_var_with_index(bdd_manager bddm, long index)
#else
bdd_var_with_index(bddm, index)
     bdd_manager bddm;
     long index;
#endif
{
  if (index < 0 || index >= bddm->vars)
    return ((bdd)0);
  return (bddm->variables[bddm->indexindexes[index]]);
}


/* bdd_var_with_id(bddm, id) returns the variable with the specified */
/* id, or null if there is no such variable. */

bdd
#if defined(__STDC__)
bdd_var_with_id(bdd_manager bddm, long indexindex)
#else
bdd_var_with_id(bddm, indexindex)
     bdd_manager bddm;
     long indexindex;
#endif
{
  if (indexindex <= 0 || indexindex > bddm->vars)
    return ((bdd)0);
  return (bddm->variables[indexindex]);
}


static
bdd
#if defined(__STDC__)
bdd_and_step(bdd_manager bddm, bdd f, bdd g)
#else
bdd_and_step(bddm, f, g)
     bdd_manager bddm;
     bdd f;
     bdd g;
#endif
{
  bdd_indexindex_type top_indexindex;
  bdd f1, f2;
  bdd g1, g2;
  bdd temp1, temp2;
  bdd result;

  BDD_SETUP(f);
  BDD_SETUP(g);
  bdd_and_step_count++;
  if (BDD_IS_CONST(f))
    {
      if (f == BDD_ZERO(bddm))
                return (f);
          else if (f == BDD_ONE(bddm))
          {
        BDD_TEMP_INCREFS(g);
        return (g);
          }
    }
  /* f is not constant. */
  if (BDD_IS_CONST(g))
    {
      if (g == BDD_ZERO(bddm))
            return (g);
          else if (g == BDD_ONE(bddm))
          {
        BDD_TEMP_INCREFS(f);
        return (f);
          }
    }
  if (BDD_IS_CONST(f) && BDD_IS_CONST(g))
  {
        /* both f and g are mtbdd constant - logical-and is undefined */
          /* error condition */
          // this may help with debugging:
          // return (BDD_ZERO(bddm));
          return ((bdd)0);
  }
  /* f and g are not constant. */
  if (BDD_SAME_OR_NEGATIONS(f, g))
    {
      if (f == g)
        {
          BDD_TEMP_INCREFS(f);
          return (f);
        }
      return (BDD_ZERO(bddm));
    }
  /* f and g are not constant and are not equal or negations. */
  if (BDD_OUT_OF_ORDER(f, g))
    BDD_SWAP(f, g);
  if (bdd_lookup_in_cache31(bddm, CACHE_TYPE_ITE, (INT_PTR)f, (INT_PTR)g, (INT_PTR)BDD_ZERO(bddm), (INT_PTR *)&result))
    return (result);
  BDD_TOP_VAR2(top_indexindex, bddm, f, g);
  BDD_COFACTOR(top_indexindex, f, f1, f2);
  BDD_COFACTOR(top_indexindex, g, g1, g2);
  temp1=bdd_and_step(bddm, f1, g1);
  temp2=bdd_and_step(bddm, f2, g2);
  result=bdd_find(bddm, top_indexindex, temp1, temp2);
  bdd_insert_in_cache31(bddm, CACHE_TYPE_ITE, (INT_PTR)f, (INT_PTR)g, (INT_PTR)BDD_ZERO(bddm), (INT_PTR)result);
  return (result);
}


static
bdd
#if defined(__STDC__)
bdd_xnor_step(bdd_manager bddm, bdd f, bdd g)
#else
bdd_xnor_step(bddm, f, g)
     bdd_manager bddm;
     bdd f;
     bdd g;
#endif
{
  int outneg;
  bdd_indexindex_type top_indexindex;
  bdd f1, f2;
  bdd g1, g2;
  bdd temp1, temp2;
  bdd result;

  BDD_SETUP(f);
  BDD_SETUP(g);
  if (BDD_IS_CONST(f))
    {
      BDD_TEMP_INCREFS(g);
      if (f == BDD_ONE(bddm))
        return (g);
      return (BDD_NOT(g));
    }
  if (BDD_IS_CONST(g))
    {
      BDD_TEMP_INCREFS(f);
      if (g == BDD_ONE(bddm))
        return (f);
      return (BDD_NOT(f));
    }
  /* f and g are not constant. */
  if (BDD_SAME_OR_NEGATIONS(f, g))
    {
      if (f == g)
        return (BDD_ONE(bddm));
      return (BDD_ZERO(bddm));
    }
  /* f and g are not constant, not same, not negations. */
  if (BDD_OUT_OF_ORDER(f, g))
    BDD_SWAP(f, g);
  if (BDD_IS_OUTPOS(g))
    outneg=0;
  else
    {
      outneg=1;
      g=BDD_NOT(g);
    }
  /* g is an uncomplemented output pointer. */
  if (bdd_lookup_in_cache31(bddm, CACHE_TYPE_ITE, (INT_PTR)f, (INT_PTR)g, (INT_PTR)BDD_NOT(g), (INT_PTR *)&result))
    return (outneg ? BDD_NOT(result) : result);
  BDD_TOP_VAR2(top_indexindex, bddm, f, g);
  BDD_COFACTOR(top_indexindex, f, f1, f2);
  BDD_COFACTOR(top_indexindex, g, g1, g2);
  temp1=bdd_xnor_step(bddm, f1, g1);
  temp2=bdd_xnor_step(bddm, f2, g2);
  result=bdd_find(bddm, top_indexindex, temp1, temp2);
  bdd_insert_in_cache31(bddm, CACHE_TYPE_ITE, (INT_PTR)f, (INT_PTR)g, (INT_PTR)BDD_NOT(g), (INT_PTR)result);
  return (outneg ? BDD_NOT(result) : result);
}


bdd
#if defined(__STDC__)
bdd_ite_step(bdd_manager bddm, bdd f, bdd g, bdd h)
#else
bdd_ite_step(bddm, f, g, h)
     bdd_manager bddm;
     bdd f;
     bdd g;
     bdd h;
#endif
{
  int outneg;
  bdd_indexindex_type top_indexindex;
  bdd f1, f2;
  bdd g1, g2;
  bdd h1, h2;
  bdd temp1, temp2;
  bdd result;

  BDD_SETUP(f);
  BDD_SETUP(g);
  BDD_SETUP(h);
  if (BDD_IS_CONST(f))
    {
      if (f == BDD_ONE(bddm))
        {
          BDD_TEMP_INCREFS(g);
          return (g);
        }
      BDD_TEMP_INCREFS(h);
      return (h);
    }
  /* f is not constant. */
  if (BDD_SAME_OR_NEGATIONS(f, g))
    {
      if (f == g)
        g=BDD_ONE(bddm);
      else
        g=BDD_ZERO(bddm);
      BDD_RESET(g);
    }
  if (BDD_SAME_OR_NEGATIONS(f, h))
    {
      if (f == h)
        h=BDD_ZERO(bddm);
      else
        h=BDD_ONE(bddm);
      BDD_RESET(h);
    }
  if (BDD_IS_CONST(g))
    {
      if (BDD_IS_CONST(h))
        {
          if (g == h)
            return (g);
          BDD_TEMP_INCREFS(f);
          if (g == BDD_ONE(bddm))
            return (f);
          return (BDD_NOT(f));
        }
      if (g == BDD_ZERO(bddm))
        return (bdd_and_step(bddm, BDD_NOT(f), h));
      return (BDD_NOT(bdd_and_step(bddm, BDD_NOT(f), BDD_NOT(h))));
    }
  else if (BDD_SAME_OR_NEGATIONS(g, h))
    {
      if (g == h)
        {
          BDD_TEMP_INCREFS(g);
          return (g);
        }
      return (bdd_xnor_step(bddm, f, g));
    }
  else if (BDD_IS_CONST(h))
    if (h == BDD_ZERO(bddm))
      return (bdd_and_step(bddm, f, g));
    else
      return (BDD_NOT(bdd_and_step(bddm, f, BDD_NOT(g))));
  /* No special cases; it's a real if-then-else. */
  if (!BDD_IS_OUTPOS(f))
    {
      f=BDD_NOT(f);
      BDD_SWAP(g, h);
    }
  /* f is now an uncomplemented output pointer. */
  if (BDD_IS_OUTPOS(g))
    outneg=0;
  else
    {
      outneg=1;
      g=BDD_NOT(g);
      h=BDD_NOT(h);
    }
  /* g is now an uncomplemented output pointer. */
  if (bdd_lookup_in_cache31(bddm, CACHE_TYPE_ITE, (INT_PTR)f, (INT_PTR)g, (INT_PTR)h, (INT_PTR *)&result))
    return (outneg ? BDD_NOT(result) : result);
  BDD_TOP_VAR3(top_indexindex, bddm, f, g, h);
  BDD_COFACTOR(top_indexindex, f, f1, f2);
  BDD_COFACTOR(top_indexindex, g, g1, g2);
  BDD_COFACTOR(top_indexindex, h, h1, h2);
  temp1=bdd_ite_step(bddm, f1, g1, h1);
  temp2=bdd_ite_step(bddm, f2, g2, h2);
  result=bdd_find(bddm, top_indexindex, temp1, temp2);
  bdd_insert_in_cache31(bddm, CACHE_TYPE_ITE, (INT_PTR)f, (INT_PTR)g, (INT_PTR)h, (INT_PTR)result);
  return (outneg ? BDD_NOT(result) : result);
}


/* bdd_ite(bddm, f, g, h) returns the BDD for "if f then g else h". */

bdd
#if defined(__STDC__)
bdd_ite(bdd_manager bddm, bdd f, bdd g, bdd h)
#else
bdd_ite(bddm, f, g, h)
     bdd_manager bddm;
     bdd f;
     bdd g;
     bdd h;
#endif
{
  if (bdd_check_arguments(3, f, g, h))
    {
      FIREWALL(bddm);
      RETURN_BDD(bdd_ite_step(bddm, f, g, h));
    }
  return ((bdd)0);
}


/* bdd_and(bddm, f, g) returns the BDD for "f and g". */

bdd
#if defined(__STDC__)
bdd_and(bdd_manager bddm, bdd f, bdd g)
#else
bdd_and(bddm, f, g)
     bdd_manager bddm;
     bdd f;
     bdd g;
#endif
{
  return (bdd_ite(bddm, f, g, BDD_ZERO(bddm)));
}


/* bdd_nand(bddm, f, g) returns the BDD for "f nand g". */

bdd
#if defined(__STDC__)
bdd_nand(bdd_manager bddm, bdd f, bdd g)
#else
bdd_nand(bddm, f, g)
     bdd_manager bddm;
     bdd f;
     bdd g;
#endif
{
  bdd temp;

  if ((temp=bdd_and(bddm, f, g)))
    return (BDD_NOT(temp));
  return ((bdd)0);
}


/* bdd_or(bddm, f, g) returns the BDD for "f or g". */

bdd
#if defined(__STDC__)
bdd_or(bdd_manager bddm, bdd f, bdd g)
#else
bdd_or(bddm, f, g)
     bdd_manager bddm;
     bdd f;
     bdd g;
#endif
{
  return (bdd_ite(bddm, f, BDD_ONE(bddm), g));
}


/* bdd_nor(bddm, f, g) returns the BDD for "f nor g". */

bdd
#if defined(__STDC__)
bdd_nor(bdd_manager bddm, bdd f, bdd g)
#else
bdd_nor(bddm, f, g)
     bdd_manager bddm;
     bdd f;
     bdd g;
#endif
{
  bdd temp;

  if ((temp=bdd_or(bddm, f, g)))
    return (BDD_NOT(temp));
  return ((bdd)0);
}


/* bdd_xor(bddm, f, g) returns the BDD for "f xor g". */

bdd
#if defined(__STDC__)
bdd_xor(bdd_manager bddm, bdd f, bdd g)
#else
bdd_xor(bddm, f, g)
     bdd_manager bddm;
     bdd f;
     bdd g;
#endif
{
  return (bdd_ite(bddm, f, BDD_NOT(g), g));
}


/* bdd_xnor(bddm, f, g) returns the BDD for "f xnor g". */

bdd
#if defined(__STDC__)
bdd_xnor(bdd_manager bddm, bdd f, bdd g)
#else
bdd_xnor(bddm, f, g)
     bdd_manager bddm;
     bdd f;
     bdd g;
#endif
{
  bdd temp;

  if ((temp=bdd_xor(bddm, f, g)))
    return (BDD_NOT(temp));
  return ((bdd)0);
}


/* bdd_identity(bddm, f) returns the BDD for f.  (The only effect is */
/* to increase the reference count for f.) */

bdd
#if defined(__STDC__)
bdd_identity(bdd_manager bddm, bdd f)
#else
bdd_identity(bddm, f)
     bdd_manager bddm;
     bdd f;
#endif
{
  if (bdd_check_arguments(1, f))
    {
      BDD_SETUP(f);
      BDD_INCREFS(f);
    }
  return (f);
}


/* bdd_not(bddm, f) returns the BDD for "not f". */

bdd
#if defined(__STDC__)
bdd_not(bdd_manager bddm, bdd f)
#else
bdd_not(bddm, f)
     bdd_manager bddm;
     bdd f;
#endif
{
  if (bdd_check_arguments(1, f))
    {
      BDD_SETUP(f);
      BDD_INCREFS(f);
      return (BDD_NOT(f));
    }
  return ((bdd)0);
}
 

/* bdd_if(bddm, f) returns the BDD for the variable at the top of f. */

bdd
#if defined(__STDC__)
bdd_if(bdd_manager bddm, bdd f)
#else
bdd_if(bddm, f)
     bdd_manager bddm;
     bdd f;
#endif
{
  if (bdd_check_arguments(1, f))
    {
      BDD_SETUP(f);
      if (BDD_IS_CONST(f))
        {
          bdd_warning(_T("bdd_if: argument is a constant"));
          return (f);
        }
      FIREWALL(bddm);
      RETURN_BDD(BDD_IF(bddm, f));
    }
  return (f);
}


/* bdd_if_index(bddm, f) returns the index for the variable at the top */
/* of f. */

long
#if defined(__STDC__)
bdd_if_index(bdd_manager bddm, bdd f)
#else
bdd_if_index(bddm, f)
     bdd_manager bddm;
     bdd f;
#endif
{
  if (bdd_check_arguments(1, f))
    {
      BDD_SETUP(f);
      if (BDD_IS_CONST(f))
        return (-1l);
      return ((long)BDD_INDEX(bddm, f));
    }
  return (-1l);
}


/* bdd_if_id(bddm, f) returns a unique identifier for the variable at */
/* the top of f. */

long
#if defined(__STDC__)
bdd_if_id(bdd_manager bddm, bdd f)
#else
bdd_if_id(bddm, f)
     bdd_manager bddm;
     bdd f;
#endif
{
  if (bdd_check_arguments(1, f))
    {
      BDD_SETUP(f);
      if (BDD_IS_CONST(f))
        return (-1l);
      return ((long)BDD_INDEXINDEX(f));
    }
  return (-1l);
}


/* bdd_then(bddm, f) returns the BDD for the "then" pointer of f. */

bdd
#if defined(__STDC__)
bdd_then(bdd_manager bddm, bdd f)
#else
bdd_then(bddm, f)
     bdd_manager bddm;
     bdd f;
#endif
{
  if (bdd_check_arguments(1, f))
    {
      BDD_SETUP(f);
      if (BDD_IS_CONST(f))
        {
          bdd_warning(_T("bdd_then: argument is a constant"));
          return (f);
        }
      f=BDD_THEN(f);
      BDD_RESET(f);
      BDD_INCREFS(f);
    }
  return (f);
}
 

/* bdd_else(bddm, f) returns the BDD for the "else" pointer of f. */

bdd
#if defined(__STDC__)
bdd_else(bdd_manager bddm, bdd f)
#else
bdd_else(bddm, f)
     bdd_manager bddm;
     bdd f;
#endif
{
  if (bdd_check_arguments(1, f))
    {
      BDD_SETUP(f);
      if (BDD_IS_CONST(f))
        {
          bdd_warning(_T("bdd_else: argument is a constant"));
          return (f);
        }
      f=BDD_ELSE(f);
      BDD_RESET(f);
      BDD_INCREFS(f);
    }
  return (f);
}


static
bdd
#if defined(__STDC__)
bdd_intersects_step(bdd_manager bddm, bdd f, bdd g)
#else
bdd_intersects_step(bddm, f, g)
     bdd_manager bddm;
     bdd f;
     bdd g;
#endif
{
  bdd_indexindex_type top_indexindex;
  bdd f1, f2;
  bdd g1, g2;
  bdd temp;

  BDD_SETUP(f);
  BDD_SETUP(g);
  if (BDD_IS_CONST(f))
    {
      if (f == BDD_ZERO(bddm))
        return (f);
      BDD_TEMP_INCREFS(g);
      return (g);
    }
  /* f is not constant. */
  if (BDD_IS_CONST(g))
    {
      if (g == BDD_ZERO(bddm))
        return (g);
      BDD_TEMP_INCREFS(f);
      return (f);
    }
  /* f and g are not constant. */
  if (BDD_SAME_OR_NEGATIONS(f, g))
    {
      if (f == g)
        {
          BDD_TEMP_INCREFS(f);
          return (f);
        }
      return (BDD_ZERO(bddm));
    }
  /* f and g are not constant and are not equal or negations. */
  if (BDD_OUT_OF_ORDER(f, g))
    BDD_SWAP(f, g);
  if (bdd_lookup_in_cache31(bddm, CACHE_TYPE_ITE, (INT_PTR)f, (INT_PTR)g, (INT_PTR)BDD_ZERO(bddm), (INT_PTR *)&temp))
    return (temp);
  BDD_TOP_VAR2(top_indexindex, bddm, f, g);
  BDD_COFACTOR(top_indexindex, f, f1, f2);
  BDD_COFACTOR(top_indexindex, g, g1, g2);
  temp=bdd_intersects_step(bddm, f1, g1);
  if (temp != BDD_ZERO(bddm))
    return (bdd_find(bddm, top_indexindex, temp, BDD_ZERO(bddm)));
  temp=bdd_find(bddm, top_indexindex, BDD_ZERO(bddm), bdd_intersects_step(bddm, f2, g2));
  if (temp == BDD_ZERO(bddm))
    bdd_insert_in_cache31(bddm, CACHE_TYPE_ITE, (INT_PTR)f, (INT_PTR)g, (INT_PTR)BDD_ZERO(bddm), (INT_PTR)temp);
  return (temp);
}


/* bdd_intersects(bddm, f, g) returns a BDD contained in "f and g", */
/* while building as few nodes as possible.  The idea is that it */
/* gives us a fast test for intersection, and, when f and g do */
/* intersect, we can call bdd_satisfy or bdd_satisfy_support on the */
/* result to get a valuation in the intersection. */

bdd
#if defined(__STDC__)
bdd_intersects(bdd_manager bddm, bdd f, bdd g)
#else
bdd_intersects(bddm, f, g)
     bdd_manager bddm;
     bdd f;
     bdd g;
#endif
{
  if (bdd_check_arguments(2, f, g))
    {
      FIREWALL(bddm);
      RETURN_BDD(bdd_intersects_step(bddm, f, g));
    }
  return ((bdd)0);
}


/* bdd_implies(bddm, f, g) is analogous to bdd_or, but it */
/* looks for things in "not f or g". */

bdd
#if defined(__STDC__)
bdd_implies(bdd_manager bddm, bdd f, bdd g)
#else
bdd_implies(bddm, f, g)
     bdd_manager bddm;
     bdd f;
     bdd g;
#endif
{
  if (bdd_check_arguments(2, f, g))
    {
      FIREWALL(bddm);
          // KMS: this was the original, but f=0 and g=1 should be valid
       RETURN_BDD(bdd_intersects_step(bddm, f, BDD_NOT(g)));
          //RETURN_BDD(bdd_or(bddm, BDD_NOT(f), g));
    }
  return ((bdd)0);
}


int
#if defined(__STDC__)
bdd_type_aux(bdd_manager bddm, bdd f)
#else
bdd_type_aux(bddm, f)
     bdd_manager bddm;
     bdd f;
#endif
{
  BDD_SETUP(f);
  if (BDD_IS_CONST(f))
    {
      if (f == BDD_ZERO(bddm))
        return (BDD_TYPE_ZERO);
      if (f == BDD_ONE(bddm))
        return (BDD_TYPE_ONE);
      return (BDD_TYPE_CONSTANT);
    }
  if (BDD_THEN(f) == BDD_ONE(bddm) && BDD_ELSE(f) == BDD_ZERO(bddm))
    return (BDD_TYPE_POSVAR);
  if (BDD_THEN(f) == BDD_ZERO(bddm) && BDD_ELSE(f) == BDD_ONE(bddm))
    return (BDD_TYPE_NEGVAR);
  return (BDD_TYPE_NONTERMINAL);
}


/* bdd_type(bddm, f) returns BDD_TYPE_ZERO if f is false, BDD_TYPE_ONE */
/* if f is true, BDD_TYPE_CONSTANT if f is an MTBDD constant, */
/* BDD_TYPE_POSVAR is f is an unnegated variable, BDD_TYPE_NEGVAR if */
/* f is a negated variable, BDD_TYPE_OVERFLOW if f is null, and */
/* BDD_TYPE_NONTERMINAL otherwise. */

int
#if defined(__STDC__)
bdd_type(bdd_manager bddm, bdd f)
#else
bdd_type(bddm, f)
     bdd_manager bddm;
     bdd f;
#endif
{
  if (bdd_check_arguments(1, f))
    return (bdd_type_aux(bddm, f));
  return (BDD_TYPE_OVERFLOW);
}


/* bdd_unfree(bddm, f) increments the reference count for f. */

void
#if defined(__STDC__)
bdd_unfree(bdd_manager bddm, bdd f)
#else
bdd_unfree(bddm, f)
     bdd_manager bddm;
     bdd f;
#endif
{
  if (f)
    {
      BDD_SETUP(f);
      BDD_INCREFS(f);
    }
}


/* bdd_free(bddm, f) decrements the reference count for f. */

void
#if defined(__STDC__)
bdd_free(bdd_manager bddm, bdd f)
#else
bdd_free(bddm, f)
     bdd_manager bddm;
     bdd f;
#endif
{
  if (f)
    {
      BDD_SETUP(f);
      if (BDD_REFS(f) == 0)
        bdd_fatal(_T("bdd_free: attempt to free node with zero references"));
      else
        BDD_DECREFS(f);
    }
}


/* bdd_vars(bddm) returns the number of variables in existence. */

long
#if defined(__STDC__)
bdd_vars(bdd_manager bddm)
#else
bdd_vars(bddm)
     bdd_manager bddm;
#endif
{
  return (bddm->vars);
}


/* bdd_total_size(bddm) returns the number of BDD nodes in existence. */

long
#if defined(__STDC__)
bdd_total_size(bdd_manager bddm)
#else
bdd_total_size(bddm)
     bdd_manager bddm;
#endif
{
  return (bddm->unique_table.entries);
}


/* bdd_cache_ratio(bddm, new_ratio) sets the cache size ratio to */
/* new_ratio and returns the old ratio. */

int
#if defined(__STDC__)
bdd_cache_ratio(bdd_manager bddm, int new_ratio)
#else
bdd_cache_ratio(bddm, new_ratio)
     bdd_manager bddm;
     int new_ratio;
#endif
{
  int old_ratio;

  old_ratio=bddm->op_cache.cache_ratio;
  if (new_ratio < 1)
    new_ratio=1;
  else if (new_ratio > 32)
    new_ratio=32;
  bddm->op_cache.cache_ratio=new_ratio;
  return (old_ratio);
}


/* bdd_node_limit(bddm, new_limit) sets the node limit to */
/* new_limit and returns the old limit. */

long
#if defined(__STDC__)
bdd_node_limit(bdd_manager bddm, long new_limit)
#else
bdd_node_limit(bddm, new_limit)
     bdd_manager bddm;
     long new_limit;
#endif
{
  long old_limit;

  old_limit=bddm->unique_table.node_limit;
  if (new_limit < 0)
    new_limit=0;
  bddm->unique_table.node_limit=new_limit;
  if (new_limit && bddm->unique_table.gc_limit > new_limit)
    bddm->unique_table.gc_limit=new_limit;
  return (old_limit);
}


/* bdd_overflow(bddm) returns 1 if the node limit has been exceeded */
/* and 0 otherwise.  The overflow flag is cleared. */

int
#if defined(__STDC__)
bdd_overflow(bdd_manager bddm)
#else
bdd_overflow(bddm)
     bdd_manager bddm;
#endif
{
  int result;

  result=bddm->overflow;
  bddm->overflow=0;
  return (result);
}


/* bdd_overflow_closure(bddm, overflow_fn, overflow_env) sets the */
/* closure to be invoked on overflow.  If overflow_fn is null, it */
/* indicates that no function should be called. */

void
#if defined(__STDC__)
bdd_overflow_closure(bdd_manager bddm, void (*overflow_fn)(bdd_manager, pointer), pointer overflow_env)
#else
bdd_overflow_closure(bddm, overflow_fn, overflow_env)
     bdd_manager bddm;
     void (*overflow_fn)();
     pointer overflow_env;
#endif
{
  bddm->overflow_fn=overflow_fn;
  bddm->overflow_env=overflow_env;
}


/* bdd_abort_closure(bddm, abort_fn, abort_env) sets a closure to be */
/* invoked when the next find operation is attempted.  This is */
/* intended for aborting BDD operations from signal handlers.  The */
/* handler should set this closure so that invoking it will cause */
/* a longjmp to a recovery routine. */

void
#if defined(__STDC__)
bdd_abort_closure(bdd_manager bddm, void (*abort_fn)(bdd_manager, pointer), pointer abort_env)
#else
bdd_abort_closure(bddm, abort_fn, abort_env)
     bdd_manager bddm;
     void (*abort_fn)();
     pointer abort_env;
#endif
{
  bddm->bag_it_fn=abort_fn;
  bddm->bag_it_env=abort_env;
}


TCHAR *
#if defined(__STDC__)
bdd_version(void)
#else
bdd_version()
#endif
{
  return (_T("1.0"));
}


/* bdd_stats(bddm, fp) prints random statistics to the file indicated */
/* by fp. */

void
#if defined(__STDC__)
bdd_stats(bdd_manager bddm, FILE *fp)
#else
bdd_stats(bddm, fp)
     bdd_manager bddm;
     FILE *fp;
#endif
{
  long i;
  long ue, ce, cs, mem;
  SIZE_T alloc;
  assoc_list q;

  ue=bddm->unique_table.entries;
  ce=bddm->op_cache.entries;
  cs=bddm->op_cache.size;
  mem=0;
  for (i=0; i < bddm->vars; ++i)
    {
      mem+=sizeof(struct var_table_);
      mem+=bddm->unique_table.tables[i]->size*sizeof(bdd);
    }
  mem=ue*sizeof(struct bdd_);
  mem+=cs*sizeof(struct cache_bin_)+ce*sizeof(struct cache_entry_);
  mem+=bddm->maxvars*(sizeof(bdd_index_type)+sizeof(bdd_indexindex_type)+sizeof(bdd)+sizeof(var_table));
  for (q=bddm->assocs, i=1; q; q=q->next, ++i);
  mem+=i*bddm->maxvars*sizeof(bdd);
  if ((alloc=mem_allocation()))
    /* mem_allocation may be meaningless depending on mem library. */
    fprintf(fp, "Memory manager bytes allocated: %ld\n", (long)alloc);
  fprintf(fp, "Approximate bytes used: %ld\n", mem);
  fprintf(fp, "Number of nodes: %ld\n", ue);
  if (bddm->unique_table.node_limit)
    fprintf(fp, "Node limit: %ld\n", bddm->unique_table.node_limit);
  else
    fprintf(fp, "Node limit: ---\n");
  fprintf(fp, "Overflow: %s\n", bddm->overflow ? "yes" : "no");
  fprintf(fp, "Approximate bytes per node: %-.2f\n", ((double)mem)/ue);
  fprintf(fp, "Cache entries: %ld\n", ce);
  fprintf(fp, "Cache size: %ld\n", 2*cs);
  fprintf(fp, "Cache load factor: %-.2f\n", ((double)ce)/(2*cs));
  fprintf(fp, "Cache look ups: %ld\n", bddm->op_cache.lookups);
  fprintf(fp, "Cache hits: %ld\n", bddm->op_cache.hits);
  if (bddm->op_cache.lookups)
    fprintf(fp, "Cache hit rate: %-.2f\n", ((double)(bddm->op_cache.hits))/bddm->op_cache.lookups);
  else
    fprintf(fp, "Cache hit rate: ---\n");
  fprintf(fp, "Cache insertions: %ld\n", bddm->op_cache.inserts);
  fprintf(fp, "Cache collisions: %ld\n", bddm->op_cache.collisions);
  fprintf(fp, "Number of variables: %ld\n", bddm->vars);
  fprintf(fp, "Number of variable associations: %d\n", i);
  fprintf(fp, "Number of garbage collections: %ld\n", bddm->unique_table.gcs);
  fprintf(fp, "Number of nodes garbage collected: %ld\n", bddm->unique_table.freed);
  fprintf(fp, "Number of find operations: %ld\n", bddm->unique_table.finds);
}


static
int
#if defined(__STDC__)
bdd_default_canonical_fn(bdd_manager bddm, INT_PTR value1, INT_PTR value2, pointer junk)
#else
bdd_default_canonical_fn(bddm, value1, value2, junk)
     bdd_manager bddm;
     INT_PTR value1;
     INT_PTR value2;
     pointer junk;
#endif
{
  /* Default transformation is treat the value as a 64-bit integer and to */
  /* negate it if it is positive. */
  return ((long)value1 > 0 || (!value1 && (long)value2 > 0));
}


static
void
#if defined(__STDC__)
bdd_default_transform_fn(bdd_manager bddm, INT_PTR value1, INT_PTR value2, INT_PTR *result1, INT_PTR *result2, pointer junk)
#else
bdd_default_transform_fn(bddm, value1, value2, result1, result2, junk)
     bdd_manager bddm;
     INT_PTR value1;
     INT_PTR value2;
     INT_PTR *result1;
     INT_PTR *result2;
     pointer junk;
#endif
{
  if (!value2)
    /* Will be a carry when taking 2's complement of value2.  Thus, */
    /* take 2's complement of high part. */
    value1= -(long)value1;
  else
    {
      value2= -(long)value2;
      value1= ~value1;
    }
  *result1=value1;
  *result2=value2;
}


/* bdd_init() creates and returns a new BDD manager. */

bdd_manager
#if defined(__STDC__)
bdd_init(void)
#else
bdd_init()
#endif
{
  bdd_manager bddm;
  long i;

  bddm=(bdd_manager)mem_get_block((SIZE_T)sizeof(struct bdd_manager_));
  bddm->overflow=0;
  bddm->overflow_fn=0;
  bddm->overflow_env=0;
  bddm->bag_it_fn=0;
  bddm->bag_it_env=0;
  bddm->canonical_fn=bdd_default_canonical_fn;
  bddm->transform_fn=bdd_default_transform_fn;
  bddm->transform_env=0;
  bddm->reorder_fn=0;
  bddm->reorder_data=0;
  bddm->vars=0;
  bddm->maxvars=30; 
  bddm->check=1;
  bddm->variables=(bdd *)mem_get_block((SIZE_T)((bddm->maxvars+1)*sizeof(bdd)));
  bddm->indexes=(bdd_index_type *)mem_get_block((SIZE_T)((bddm->maxvars+1)*sizeof(bdd_index_type)));
  bddm->indexindexes=(bdd_indexindex_type *)mem_get_block((SIZE_T)(bddm->maxvars*sizeof(bdd_indexindex_type)));
  bddm->indexes[BDD_CONST_INDEXINDEX]=BDD_MAX_INDEX;
  for (i=0; i < REC_MGRS; ++i)
    bddm->rms[i]=mem_new_rec_mgr(MIN_REC_SIZE+ALLOC_ALIGNMENT*i);
  bddm->temp_assoc.assoc=(bdd *)mem_get_block((SIZE_T)((bddm->maxvars+1)*sizeof(bdd)));
  bddm->temp_assoc.last= -1;
  for (i=0; i < bddm->maxvars; ++i)
    bddm->temp_assoc.assoc[i+1]=0;
  bddm->curr_assoc_id= -1;
  bddm->curr_assoc= &bddm->temp_assoc;
  bddm->assocs=0;
  bddm->temp_op= -1;
  bddm->super_block=(block)BDD_NEW_REC(bddm, sizeof(struct block_));
  bddm->super_block->num_children=0;
  bddm->super_block->children=0;
  bddm->super_block->reorderable=1;
  bddm->super_block->first_index= -1;
  bddm->super_block->last_index=0;
  bdd_init_unique(bddm);
  bdd_init_cache(bddm);
  bddm->one=bdd_find_terminal(bddm, ~(INT_PTR)0, ~(INT_PTR)0);
  bddm->one->refs=BDD_MAX_REFS;
  bddm->one->mark=0;
  bddm->zero=BDD_NOT(bddm->one);
  if (sizeof(double) > 2*sizeof(long))
    bdd_warning(_T("bdd_init: portability problem for bdd_satisfying_fraction"));
  return (bddm);
}


static
void
#if defined(__STDC__)
bdd_free_block(bdd_manager bddm, block b)
#else
bdd_free_block(bddm, b)
     bdd_manager bddm;
     block b;
#endif
{
  long i;

  if (b->children)
    {
      for (i=0; i < b->num_children; ++i)
        bdd_free_block(bddm, b->children[i]);
      mem_free_block((pointer)b->children);
    }
  BDD_FREE_REC(bddm, (pointer)b, sizeof(struct block_));
}


/* bdd_quit(bddm) frees all storage associated with the BDD manager */
/* bddm. */

void
#if defined(__STDC__)
bdd_quit(bdd_manager bddm)
#else
bdd_quit(bddm)
     bdd_manager bddm;
#endif
{
  int i;
  assoc_list p, q;

  bdd_free_unique(bddm);
  bdd_free_cache(bddm);
  mem_free_block((pointer)bddm->variables);
  mem_free_block((pointer)bddm->indexes);
  mem_free_block((pointer)bddm->indexindexes);
  mem_free_block((pointer)bddm->temp_assoc.assoc);
  for (p=bddm->assocs; p; p=q)
    {
      q=p->next;
      mem_free_block((pointer)p->va.assoc);
      BDD_FREE_REC(bddm, (pointer)p, sizeof(struct assoc_list_));
    }
  bdd_free_block(bddm, bddm->super_block);
  for (i=0; i < REC_MGRS; ++i)
    mem_free_rec_mgr(bddm->rms[i]);
  mem_free_block((pointer)bddm);
}
