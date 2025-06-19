require 'rails_helper'

RSpec.describe "利用規約、プライバシーポリシー", type: :system do
  describe "利用規約画面" do
    it "利用規約画面に遷移できる" do
      visit terms_path
      expect(current_path).to eq terms_path
      expect(page).to have_content("利用規約")
    end
  end

  describe "プライバシーポリシー画面" do
    it "プライバシーポリシー画面に遷移できる" do
      visit policy_path
      expect(current_path).to eq policy_path
      expect(page).to have_content("プライバシーポリシー")
    end
  end
end
