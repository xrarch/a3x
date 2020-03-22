.ds ANTE
.dl Entry

.extern a3xEntry

.extern a3xReturn ;see a3x.df

Entry:

push ivt

;push firmware context
pushv r5, sp

call a3xEntry

call a3xReturn