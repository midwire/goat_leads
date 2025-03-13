puts('>>> Seeding FAQ')
faq = Faq.find_or_create_by(order: 1)
faq.update(
  question: 'What makes G.O.A.T. Leads different from other lead generation services?',
  answer: ' GOAT Leads sets itself apart by integrating four essential pillars: High Intent Vetted Leads, Real-Time Delivery, Exclusivity, and Competitive Pricing. This unique combination ensures that you receive high-quality, exclusive leads at an affordable price, helping you grow your business sustainably.'
)
faq = Faq.find_or_create_by(order: 2)
faq.update(
  question: 'How does your lead generation process work?',
  answer: "Our process is straightforward: Step 1: Order Your Leads - Choose leads that match your business goals and complete our order form. Step 2: Receive Resources - After confirmation, you'll get tailored resources and high-converting scripts. Step 3: Get Your Leads - Expect delivery of your leads within five business days. Step 4: Manage Your Subscription - You have full control to adjust, scale, or cancel your subscription anytime."
)
faq = Faq.find_or_create_by(order: 3)
faq.update(
  question: 'Are the leads exclusive?',
  answer: 'Yes, all our leads are 100% exclusive and never resold or duplicated. This exclusivity ensures that you are the only agent receiving that lead, increasing your chances of conversion and profitability.'
)
faq = Faq.find_or_create_by(order: 4)
faq.update(
  question: 'How quickly will I receive my leads?',
  answer: 'Once your order is confirmed, you can expect to receive your leads within five business days. We prioritize fast and seamless delivery so you can focus on growing your business.'
)
faq = Faq.find_or_create_by(order: 5)
faq.update(
  question: 'Can I customize my lead order?',
  answer: "Absolutely! We offer a range of lead options tailored to various niches and target audiences. If you're unsure about which leads to order, you can always book a consultation for expert advice."
)
faq = Faq.find_or_create_by(order: 6)
faq.update(
  question: 'What type of leads do you offer?',
  answer: 'We provide high-quality life insurance leads, including: Indexed Universal Life Leads Mortgage Protection Leads Veteran Leads Final Expense Leads These leads are generated through advanced targeting techniques to ensure you connect with high-intent prospects.'
)
faq = Faq.find_or_create_by(order: 7)
faq.update(
  question: 'How do you ensure the quality of your leads?',
  answer: 'Our leads are generated through a proprietary CRM system built by agents for agents. We implement advanced targeting and vetting processes to ensure that only high-intent leads reach your business, driving real results and conversions.'
)
faq = Faq.find_or_create_by(order: 8)
faq.update(
  question: "What if I'm not satisfied with the leads I receive?",
  answer: 'Customer satisfaction is our top priority. If you encounter any issues with your leads, please reach out to our support team. We’re here to assist you and address your concerns promptly.'
)
faq = Faq.find_or_create_by(order: 9)
faq.update(
  question: 'Is there a minimum order requirement for leads?',
  answer: 'We do not have strict minimum order requirements; however, we recommend selecting a quantity that aligns with your business goals for optimal results. Feel free to contact us for more details on your options.'
)
faq = Faq.find_or_create_by(order: 10)
faq.update(
  question: 'How can I get started with G.O.A.T. Leads?',
  answer: "Getting started is easy! Visit our website to explore our lead options, complete the order form, and follow the outlined steps. If you have questions or need assistance, don't hesitate to book a call with us."
)
