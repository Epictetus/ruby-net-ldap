# $Id$
#
# LDAP Entry (search-result) support classes
#
#
#----------------------------------------------------------------------------
#
# Copyright (C) 2006 by Francis Cianfrocca. All Rights Reserved.
#
# Gmail: garbagecat10
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
#
#---------------------------------------------------------------------------
#




module Net
class LDAP


  class Entry

    def initialize dn = nil
      @myhash = Hash.new {|k,v| k[v] = [] }
      @myhash[:dn] = [dn]
    end


    def []= name, value
      sym = name.to_s.downcase.intern
      @myhash[sym] = value
    end


    #--
    # We have to deal with this one as we do []=
    # because this one and not the other one gets called
    # in formulations like entry["CN"] << cn.
    #
    def [] name
      name = name.to_s.downcase.intern unless name.is_a?(Symbol)
      @myhash[name]
    end

    def dn
      self[:dn][0]
    end

    def attribute_names
      @myhash.keys
    end

    def each
      if block_given?
        attribute_names.each {|a| yield a, self[a] }
      end
    end

    alias_method :each_attribute, :each

  end # class Entry


end # class LDAP
end # module Net


