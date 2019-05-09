require "rails_helper"

RSpec.describe UserMailer, type: :mailer do
  describe "send_mail_test" do
    let(:mail) { UserMailer.send_mail_test }

    it "renders the headers" do
      expect(mail.subject).to eq("Send mail test")
      expect(mail.to).to eq(["to@example.org"])
      expect(mail.from).to eq(["from@example.com"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match("Hi")
    end
  end

end
