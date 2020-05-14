.ds ANTE
.dl Entry

.extern a3xEntry

.extern a3xReturn ;see a3x.df

Entry:

push lr

push ev

;push firmware context
swd.l vs, zero, sp

jal a3xEntry

jal a3xReturn