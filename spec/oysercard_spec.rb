require 'oystercard'
describe Oystercard do
  let (:station) {double :station}
  describe '#balance' do
    it 'new card should have zero balance' do
      expect(subject.balance).to eq 0
    end
  end

  describe '#top_up' do
    it 'should increase balance' do
      subject.top_up(1)
      expect(subject.balance).to eq 1
    end

    it 'should raise error if exceeds maximum balance' do
      message = "Exceeds maximum balance (#{Oystercard::MAX_BALANCE})"
      expect { subject.top_up(91) }.to raise_error(message)
    end
  end

  describe '#in_journey?' do
    it 'is false' do
      expect(subject).not_to be_in_journey
    end
    it 'is true' do
      subject.instance_variable_set(:@entry_station, station)
      expect(subject).to be_in_journey
    end
  end

  describe '#touch_in' do
    it 'start journey' do
      subject.instance_variable_set(:@balance, 10)
      subject.touch_in(station)
      expect(subject).to be_in_journey
    end

    it 'raise error if balance is below min' do
      expect { subject.touch_in(station) }.to raise_error "Not enough money"
    end

    it 'should record entry station' do
      subject.instance_variable_set(:@balance, 10)
      subject.touch_in(station)
      expect(subject.entry_station).to eq station
    end

  end

  describe '#touch_out' do
    it 'ends journey' do
      subject.touch_out
      expect(subject).not_to be_in_journey
    end

    it 'deducts the minimum fare' do
      expect { subject.touch_out }.to change{ subject.balance }.by(-Oystercard::MIN_FARE)
    end
  end

end
