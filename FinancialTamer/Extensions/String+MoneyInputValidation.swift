extension String {
    func validatedMoneyInput() -> String {
        let allowed = "0123456789.,"
        var filtered = self.filter { allowed.contains($0) }
        filtered = filtered.replacingOccurrences(of: ",", with: ".")
        let parts = filtered.split(separator: ".", omittingEmptySubsequences: false)
        if parts.count > 1 {
            filtered = parts[0] + "." + parts[1...].joined()
        }
        return filtered
    }
}
