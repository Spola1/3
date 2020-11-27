# frozen_string_literal: true

class WagonCargo < Wagon
  attr_reader :volume
  def initialize(id, volume)
    @type = 'Грузовой'
    super
  end

  def upload(vlm)
    raise 'Не хватает места для загрузки!' if (@occuped + vlm) > @capacity
    @occuped += vlm
  end

  def unload(vlm)
    raise 'Нечего разгружать!' if (@occuped - vlm).negative?
    @occuped -= vlm
  end
end
