# lib/validators.nix — NixOS module type validators
# These extend lib.types with project-specific validation logic.

{ lib }:

rec {
  # Non-empty list: rejects [] but allows null for nullOr wrapping
  nonEmptyListOf = elemType: lib.types.addCheck
    (lib.types.listOf elemType)
    (lst: lst != []);

  # Null or non-empty list (use instead of nullOr (listOf ...) when you
  # want null ≠ [])
  nullOrNonEmptyListOf = elemType:
    lib.types.nullOr (nonEmptyListOf elemType);

  # isSet: true when a nullable option has been explicitly configured
  # (i.e., not null). Works with nullOr (enum [...]), nullOr str, etc.
  isSet = val: val != null;
}
