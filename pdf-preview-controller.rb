
pdf = WickedPdf.new.pdf_from_string(
  render_to_string(template_path, layout: 'pdf'),
)

# save pdf
save_path = Rails.root.join('pdfs', "#{pdf_name}.pdf")
File.open(save_path, 'wb') do |file|
  file << pdf
end
# deliver
puts "*" * 100
puts "is file exist? #{ File.exist?(save_path) }"
puts "*" * 100
puts "===DoReportSendPdfJob.perform_later==="
DoReportSendPdfJob.perform_later(filter_options[:district_id], save_path.to_s)
puts "*" * 100

@site.update(latest_generated_pdf_name: "#{pdf_name}.pdf")
send_data pdf, type: 'application/pdf', disposition: 'inline'
