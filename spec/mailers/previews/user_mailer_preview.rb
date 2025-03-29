# frozen_string_literal: true

# Preview all emails at http://localhost:3000/rails/mailers/user_mailer
class UserMailerPreview < ActionMailer::Preview
  def verify_email
    UserMailer.verify_email(User.take.id)
  end

  def new_user_welcome
    UserMailer.new_user_welcome(User.take.id)
  end

  def new_lead
    lead = Lead.where.not(delivered_at: nil).take
    UserMailer.new_lead(lead.id)
  end

  def new_mortgage_protection_lead
    UserMailer.new_lead(test_lead('MortgageProtectionLeadPremium').id)
  end

  def new_veteran_lead
    UserMailer.new_lead(test_lead('VeteranLeadPremium').id)
  end

  def new_iul_lead
    UserMailer.new_lead(test_lead('IndexUniversalLifeLeadPremium').id)
  end

  def new_fex_lead
    UserMailer.new_lead(test_lead('FinalExpenseLeadPremium').id)
  end

  private

  def test_lead(klass)
    factory = klass.underscore

    # Create the lead order
    lead_order = LeadOrder.find_or_initialize_by(notes: 'mp-test')
    lead_order.update(
      FactoryBot.attributes_for(:lead_order).merge(
        lead_class: klass,
        user_id: user.id
      )
    )

    lead = klass.constantize.find_or_initialize_by(external_lead_id: 'mp-test')
    lead.update(
      FactoryBot.attributes_for(factory).merge(
        lead_order: lead_order,
        delivered_at: Time.current
      )
    )
    lead
  end

  def user
    @user ||= begin
      u = User.find_or_initialize_by(external_id: 'mailer-test')
      u.update(
        FactoryBot.attributes_for(
          :user,
          :agent,
          :confirmed,
          password: 'asdfasdf',
          password_confirmation: 'asdfasdf'
        )
      )
      u
    end
  end
end
