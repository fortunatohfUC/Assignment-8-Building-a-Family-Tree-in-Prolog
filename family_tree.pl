% ============================================================
% Family Tree Program in Prolog
% Author: [Your Name]
% Date:   [Date]
%
% This program models my fictional family tree using Prolog
% facts and rules. It can answer questions about who is
% related to whom through logical inference and recursion.
% ============================================================

% ------------------------------------------------------------
% Gender Facts
% I picked names that felt realistic and easy to follow.
% ------------------------------------------------------------
male(tom).
male(jack).
male(alex).
male(ben).
male(luke).
male(noah).
male(ryan).

female(anna).
female(sophie).
female(kate).
female(lisa).
female(emma).
female(olivia).
female(mia).

% ------------------------------------------------------------
% Parent Relationships
%
% Here is how the family tree is structured:
%
%   Generation 1 (Grandparents):
%       Tom + Anna  -->  Jack, Sophie
%       Ben + Kate  -->  Alex, Lisa
%
%   Generation 2 (Parents):
%       Jack + Lisa   -->  Luke, Emma
%       Alex + Sophie -->  Noah, Olivia
%
%   Generation 3 (Youngest):
%       Luke + Mia  -->  Ryan
%
% I set it up so that Jack married Lisa and Alex married
% Sophie, which creates the cousin links I needed to test.
% ------------------------------------------------------------

% Tom and Anna are parents of Jack and Sophie
parent(tom, jack).
parent(tom, sophie).
parent(anna, jack).
parent(anna, sophie).

% Ben and Kate are parents of Alex and Lisa
parent(ben, alex).
parent(ben, lisa).
parent(kate, alex).
parent(kate, lisa).

% Jack and Lisa are parents of Luke and Emma
parent(jack, luke).
parent(jack, emma).
parent(lisa, luke).
parent(lisa, emma).

% Alex and Sophie are parents of Noah and Olivia
parent(alex, noah).
parent(alex, olivia).
parent(sophie, noah).
parent(sophie, olivia).

% Luke and Mia are parents of Ryan
parent(luke, ryan).
parent(mia, ryan).

% ------------------------------------------------------------
% Derived Relationships
% These rules let Prolog figure out connections that I did
% not have to state explicitly as facts.
% ------------------------------------------------------------

% A father is a male parent.
father(X, Y) :- male(X), parent(X, Y).

% A mother is a female parent.
mother(X, Y) :- female(X), parent(X, Y).

% X is a child of Y if Y is a parent of X.
child(X, Y) :- parent(Y, X).

% Sons and daughters
son(X, Y) :- male(X), parent(Y, X).
daughter(X, Y) :- female(X), parent(Y, X).

% Grandparent — just chain two parent links together.
grandparent(X, Y) :- parent(X, Z), parent(Z, Y).

% More specific versions
grandfather(X, Y) :- male(X), grandparent(X, Y).
grandmother(X, Y) :- female(X), grandparent(X, Y).

% Siblings share at least one parent.
% The X \= Y part stops Prolog from saying someone
% is their own sibling, which tripped me up at first.
sibling(X, Y) :- parent(Z, X), parent(Z, Y), X \= Y.

% Brother and sister
brother(X, Y) :- male(X), sibling(X, Y).
sister(X, Y) :- female(X), sibling(X, Y).

% Uncle and aunt — a sibling of your parent.
uncle(X, Y) :- brother(X, Z), parent(Z, Y).
aunt(X, Y) :- sister(X, Z), parent(Z, Y).

% Cousins — their parents are siblings.
% This was my favorite rule to write because it
% builds cleanly on the sibling rule.
cousin(X, Y) :- parent(A, X), parent(B, Y), sibling(A, B).

% ------------------------------------------------------------
% Recursive Rules
%
% These let Prolog walk up or down the tree to any depth.
% The base case has to come first, otherwise Prolog can
% get stuck in an infinite loop.
% ------------------------------------------------------------

% Base case: a parent is an ancestor.
ancestor(X, Y) :- parent(X, Y).

% Recursive case: a parent of an ancestor is also an ancestor.
ancestor(X, Y) :- parent(X, Z), ancestor(Z, Y).

% Descendant is just ancestor flipped around.
descendant(X, Y) :- ancestor(Y, X).
