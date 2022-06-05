# struct person {
#     firstname,  # 40 bytes
#     lastname,   # 40 bytes
#     address,    # 240 bytes
#     age         # 8 bytes
# }

.equ RECORD_FIRSTNAME, 0
.equ RECORD_LASTNAME, 40
.equ RECORD_ADDRESS, 80
.equ RECORD_AGE, 320

.equ RECORD_SIZE, 328
