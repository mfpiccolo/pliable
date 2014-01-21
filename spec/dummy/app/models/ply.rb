class Ply < Pliable::Ply

  def link
    "https://localhost:3001/invoices/#{self.oid}"
  end

end
