class Magic < Measured::Measurable
  conversion.base :magic_missile, :magic_missiles
  conversion.add :fire, :fireball, :fireballs, value: "2/3 magic_missile"
  conversion.add :ice, value: "2 magic_missile"
  conversion.add :arcane, value: "10 magic_missile"
  conversion.add :ultima, value: "10 arcane"
end
