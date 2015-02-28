class Magic < Measured::Measurable

  conversion.set_base :magic_missile,
    aliases: [:magic_missiles]

  conversion.add :fireball,
    aliases: [:fire, :fireballs],
    value: "2/3 magic_missile"

  conversion.add :ice,
    value: "2 magic_missile"

  conversion.add :arcane,
    value: "10 magic_missile"

  conversion.add :ultima,
    value: "10 arcane"

end
