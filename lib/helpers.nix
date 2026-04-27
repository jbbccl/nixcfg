{ lib }:
{
  # Nullable enum (null = disabled, string = which variant)
  mkNullOrEnum = desc: values: lib.mkOption {
    type = lib.types.nullOr (lib.types.enum values);
    default = null;
    description = desc;
  };

  # Nullable list-of-enum (null = disabled, list = which variants)
  mkNullOrListEnum = desc: values: lib.mkOption {
    type = lib.types.nullOr (lib.types.listOf (lib.types.enum values));
    default = null;
    description = desc;
  };
}
