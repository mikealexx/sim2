# Operands to multiply
.data
a: .word 0xBAD
b: .word 0xFEED

.text
main:   # Load data from memory
		la      t3, a
        lw      t3, 0(t3)
        la      t4, b
        lw      t4, 0(t4)
        
        # t6 will contain the result
        add		t6, x0, x0

        # Mask for 16x8=24 multiply
        ori		t0, x0, 0xff
        slli	t0, t0, 8
        ori		t0, t0, 0xff
        slli	t0, t0, 8
        ori		t0, t0, 0xff
		
		# CODE: 16x16
		andi 	t5, t4, 0xff #load only first 8 bits from b
		mul 	t1, t3, t5 #first multiplication of 16x8
		and		t1, t1, t0
		
		srli 	t5, t4, 8 #shift the 8 bits to the right
		mul 	t2, t3, t5
		and 	t2, t2, t0
		slli 	t2, t2, 8 #shift the result 8 bits to the left
		
		add 	t6, t1, t2 #add the results of the two multiplications
		
finish: addi    a0, x0, 1
        addi    a1, t6, 0
        ecall # print integer ecall
        addi    a0, x0, 10
        ecall # terminate ecall


