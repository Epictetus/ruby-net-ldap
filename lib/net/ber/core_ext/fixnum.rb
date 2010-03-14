module Net::BER::Extensions::Fixnum
  # Converts the fixnum to BER format.
  def to_ber
    "\002#{to_ber_internal}"
  end

  # Converts the fixnum to BER enumerated format.
  def to_ber_enumerated
    "\012#{to_ber_internal}"
  end

  # Converts the fixnum to BER length encodining format.
  def to_ber_length_encoding
    if self <= 127
      [self].pack('C')
    else
      i = [self].pack('N').sub(/^[\0]+/,"")
      [0x80 + i.length].pack('C') + i
    end
  end

  # Generate a BER-encoding for an application-defined INTEGER. Example:
  # SNMP's Counter, Gauge, and TimeTick types.
  def to_ber_application tag
    [0x40 + tag].pack("C") + to_ber_internal
  end

  #--
  # Called internally to BER-encode the length and content bytes of a Fixnum.
  # The caller will prepend the tag byte.
  #++
  MAX_SIZE = 0.size
  def to_ber_internal
    size = MAX_SIZE
    while size > 1
      break if (self & (0xff << (size - 1) * 8)) > 0 
      size -= 1
    end

    result = [size]

    while size > 0
      # right shift size-1 bytes, mask with 0xff 
      result << ((self >> ((size - 1) * 8)) & 0xff)
      size -= 1
    end

    result.pack('C*')
  end
  private :to_ber_internal
end
