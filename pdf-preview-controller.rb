
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



render  pdf: pdf_name,
        template: template_path,
        layout: 'pdf',
        orientation: 'Portrait',
        lowquality: false,
        page_offset: 0,
        save_to_file: Rails.root.join('pdfs', "#{pdf_name}.pdf"),
        disable_smart_shrinking: false,
        zoom: 1,
        book: false,
        print_media_type: false,
        dpi: 300,
        encoding: 'utf8',
        page_size: 'A4',
        default_protocol: 'https',
        header: { right: '[page] of [topage]' },
        content_type: 'application/pdf',
        # Delay for chartjs to execute before render pdf
        javascript_delay: ENV['JS_DELAY_IN_MILLISECONDS']
