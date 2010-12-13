require File.dirname(__FILE__) + '/spec_helper'

describe 'persistent storage for filters' do
  context 'initializing' do
    context 'the hash argument sets the mode of operation for storage' do
      it 'to disk storage, in a specific path if :disk => "some directory path"'
      it "to disk storage, in the system's TMP dir if :disk"
      it 'to memcache storage if :memcache => "server address/port"'
      it 'to memcache storage, localhost:11211 if :memcache"'
      it "raises UnknownStorage for weird stuff"
    end
  end

  context 'writing' do
    it "writes to disk with a hash-like syntax"
  end

  context 'reading' do
    it "reads from disk"
  end
end