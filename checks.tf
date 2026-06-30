# check blocks run after every plan and apply and emit a warning (without blocking) when an
# invariant is violated. They are the place to enforce module-wide consistency.

# A NAT gateway needs at least one public IP or public IP prefix to provide outbound connectivity;
# without one it does nothing useful.
check "has_outbound_ip" {
  assert {
    condition     = length(var.public_ip_associations) > 0 || length(var.public_ip_prefix_associations) > 0
    error_message = "The NAT gateway has no public IP or prefix associated, so it provides no outbound connectivity."
  }
}

# A NAT gateway with no subnets associated is not in the data path for any subnet.
check "associated_to_a_subnet" {
  assert {
    condition     = length(var.subnet_associations) > 0
    error_message = "The NAT gateway is not associated with any subnet, so no subnet routes outbound through it."
  }
}
