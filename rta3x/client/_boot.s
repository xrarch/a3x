.ds ANTE
.dl Entry

.extern a3xEntry

.extern a3xReturn ;see a3x.df

.extern a3xFwctx

Entry:
mov t0, sp
subi sp, sp, 8
s.l sp, zero, t0
sio.l sp, 4, lr

la at, a3xFwctx
s.l at, zero, sp

jal a3xEntry

mov a0, v0

j a3xReturn