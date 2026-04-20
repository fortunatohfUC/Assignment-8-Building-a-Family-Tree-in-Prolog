% ============================================================
% Family Tree Program in Prolog
% ============================================================
% This program defines family relationships using facts and
% rules, and supports queries using logical inference and
% recursion.
% ============================================================

% ------------------------------------------------------------
% 1. Basic Facts: Gender
% ------------------------------------------------------------
male(john).
male(james).
male(robert).
male(william).
male(david).
male(michael).
male(daniel).

female(mary).
female(susan).
female(linda).
female(elizabeth).
female(sarah).
female(emily).
female(jessica).

% ------------------------------------------------------------
% 2. Basic Facts: Parent Relationships
% ------------------------------------------------------------
% Generation 1 (Grandparents)
%   John + Mary -> James, Susan
%   Robert + Linda -> William, Elizabeth

parent(john, james).
parent(john, susan).
parent(mary, james).
parent(mary, susan).

parent(robert, william).
parent(robert, elizabeth).
parent(linda, william).
parent(linda, elizabeth).

% Generation 2 (Parents)
%   James + Elizabeth -> David, Sarah
%   William + Susan -> Michael, Emily

parent(james, david).
parent(james, sarah).
parent(elizabeth, david).
parent(elizabeth, sarah).

parent(william, michael).
parent(william, emily).
parent(susan, michael).
parent(susan, emily).

% Generation 3
%   David + Jessica -> Daniel
parent(david, daniel).
parent(jessica, daniel).

% ------------------------------------------------------------
% 3. Derived Relationships Using Rules
% ------------------------------------------------------------

% Father: X is the father of Y if X is male and X is a parent of Y.
father(X, Y) :- male(X), parent(X, Y).

% Mother: X is the mother of Y if X is female and X is a parent of Y.
mother(X, Y) :- female(X), parent(X, Y).

% Child: X is a child of Y if Y is a parent of X.
child(X, Y) :- parent(Y, X).

% Son: X is a son of Y if X is male and Y is a parent of X.
son(X, Y) :- male(X), parent(Y, X).

% Daughter: X is a daughter of Y if X is female and Y is a parent of X.
daughter(X, Y) :- female(X), parent(Y, X).

% Grandparent: X is a grandparent of Y if X is a parent of Z
% and Z is a parent of Y (recursive chain of two parent links).
grandparent(X, Y) :- parent(X, Z), parent(Z, Y).

% Grandfather: X is a grandfather of Y.
grandfather(X, Y) :- male(X), grandparent(X, Y).

% Grandmother: X is a grandmother of Y.
grandmother(X, Y) :- female(X), grandparent(X, Y).

% Sibling: X and Y are siblings if they share the same parent
% and are not the same person.
sibling(X, Y) :- parent(Z, X), parent(Z, Y), X \= Y.

% Brother: X is a brother of Y.
brother(X, Y) :- male(X), sibling(X, Y).

% Sister: X is a sister of Y.
sister(X, Y) :- female(X), sibling(X, Y).

% Uncle: X is an uncle of Y if X is the brother of a parent of Y.
uncle(X, Y) :- brother(X, Z), parent(Z, Y).

% Aunt: X is an aunt of Y if X is the sister of a parent of Y.
aunt(X, Y) :- sister(X, Z), parent(Z, Y).

% Cousin: X and Y are cousins if their parents are siblings.
cousin(X, Y) :- parent(A, X), parent(B, Y), sibling(A, B).

% ------------------------------------------------------------
% 4. Recursive Rules: Ancestor and Descendant
% ------------------------------------------------------------

% Base case: X is an ancestor of Y if X is a parent of Y.
ancestor(X, Y) :- parent(X, Y).

% Recursive case: X is an ancestor of Y if X is a parent of Z
% and Z is an ancestor of Y.
ancestor(X, Y) :- parent(X, Z), ancestor(Z, Y).

% Descendant: X is a descendant of Y if Y is an ancestor of X.
descendant(X, Y) :- ancestor(Y, X).
