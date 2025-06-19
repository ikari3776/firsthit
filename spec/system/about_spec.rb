require 'rails_helper'

RSpec.describe "運営者情報", type: :system do
  describe "運営者情報画面" do
    it "運営者情報画面に遷移できる" do
      visit about_path
      expect(page).to have_content("運営者情報")
    end
  end
end
