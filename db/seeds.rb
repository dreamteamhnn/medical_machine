puts "#=== Clear all data before seed ===#"

Rake::Task["db:migrate:reset"].invoke

Rake::Task["master_data:recreate"].invoke

FileUtils.rm_rf("public/uploads")

puts "create label"
[{sale: "Sản phẩm khuyến mại"}, {hot: "Sản phẩm HOT"}, {weekly: "Sản phẩm nổi bật tuần"}, {trend: "Sản phẩm trending"}, {feature: "Sản phẩm nổi bật"}].each_with_index do |c, i|
  Label.create! title: c.values.first, block_order: i + 1, short_title: c.keys.first.to_s
end
puts "create label OK"

puts "Create Category and Relation 1,2 real"
category_array =
[
  ["Thiết bị thí nghiệm",
    [
      ["Kính hiển vi",  ["Kính hiển vi 1 mắt",
                        "Kính hiển vi 2 mắt",
                        "Kính hiển vi soi nổi",
                        "Kính hiển vi kỹ thuật số",
                        "Kính hiển vi phản pha",
                        "Kính hiển vi soi ngược"]],
      ["Máy ly tâm", ["Máy ly tâm nhỏ",
                      "Máy ly tâm để bàn",
                      "Máy ly tâm máu",
                      "Máy ly tâm Microlife",
                      "Máy ly tâm dung tích lớn"]],
      ["Nồi hấp tiệt trùng", ["Nồi hấp để bàn",
                              "Nồi hấp xách tay",
                              "Nồi hấp đứng",
                              "Nồi hấp dung tích lớn"]],
      ["Tủ ấm - Tủ sấy", ["Tủ ấm",
                          "Tủ ấm lạnh",
                          "Tủ ấm lắc",
                          "Tủ sấy",
                          "Tủ sấy chân không",
                          "Tủ sấy đông khô"]],
      ["Tủ vi khí hậu", []],
      ["Tủ hút", ["Tủ hút có đường ống",
                  "Tủ hút khônng đường ống" ]],
      ["Tủ cấy vi sinh", []],
      ["Tủ an toàn sinh học",  ["Tủ an toàn cấp 1",
                                "Tủ an toàn cấp 2",
                                "Tủ an toàn cấp 3"]],
      ["Tủ lạnh - Tủ âm sâu",  ["Tủ mát",
                                "Tủ bảo quản Vaccine",
                                "Tủ lạnh âm sâu"]],
      ["Các loại bể",  ["Bể rửa siêu âm",
                        "Bể cách thuỷ",
                        "Bể điều nhiệt lạnh"]],
      ["Bơm chân không", ["Bơm dầu"]],
      ["Máy lắc - Máy khuấy",  ["Máy lắc ngang",
                                "Máy lắc tròn",
                                "Tủ ấm lắc",
                                "Máy khuấy từ",
                                "Máy khuấy đũa",
                                "Máy đồng hoá"]],
      ["Máy cất nước - Máy lọc nước",  ["Máy cất nước 1 lần",
                                        "Máy cất nước 2 lần",
                                        "Máy lọc nước siêu sạch"]],
      ["Cân điện tử",  ["Cân kỹ thuật",
                        "Cân phân tích",
                        "Cân sấy ẩm",
                        "Cân tỷ trọng"]]
    ]
  ],

  ["Thiết bị đo lường",
    [
      ["Thiết bị đo cầm tay",[]],
      ["Máy đo đa chỉ tiêu nước",[]],
      ["Khúc xạ kế",[]],
      ["Máy đo độ nhớt",[]],
      ["Máy đo lực bóp tay",[]],
      ["Máy đo độ ẩm",[]],
      ["Máy đếm khuẩn lạc",[]],
      ["Máy đo chỉ tiêu dược",[]],
      ["Máy đo độ cứng thép",[]],
      ["Tủ so màu",[]],
      ["Quang kế ngọn lửa",[]],
      ["Thiết bị phân tích nhiệt lượng",[]]
    ]
  ],

  ["Thiết bị y tế",
    [
      ["Nồi hấp",[]],
      ["Máy ly tâm",[]],
      ["Kính hiển vi",[]],
      ["Máy cất nước",[]],
      ["Tủ cấy",[]],
      ["Tủ an toàn sinh học",[]],
      ["Tủ bảo quản vaccine",[]],
      ["Tủ trữ máu",[]],
      ["Tủ lạnh âm sâu",[]],
      ["Tủ ấm",[]],
      ["Tủ sấy",[]],
      ["Bể ổn nhiệt",[]]
    ]
  ],

  ["Thiết bị công nghiệp",
    [
      ["Kính hiển vi công nghiệp",[]],
      ["Kính lúp công nghiệp",[]],
      ["Kính hiển vi điện tử",[]],
      ["Thiết bị đo lường công nghiệp",[]],
      ["Thiết bị phòng sạch",[]],
      ["Lò nung ủ thép",[]],
      ["Lò tôi Cacbon",[]]
    ]
  ],

  ["Dụng cụ, vật tư",
    [
      ["Chén Platin",[]],
      ["Dụng cụ thuỷ tinh",[]],
      ["Micropipet",[]],
      ["Kẹp - chén nung",[]]
    ]
  ],

  ["Phụ kiện thay thế",
    [
      ["Phụ kiện lò nung",[]],
      ["Phụ kiện nồi hấp",[]],
      ["Phụ kiện máy cất nước",[]],
      ["Phụ kiện máy ly tâm",[]],
      ["Vật tư - Linh kiện",[]],
      ["Dịch vụ sửa chữa",[]],
    ]
  ]
]

category_array.each_with_index do |c1, i1|
  cate1 = Category.create! name: c1.first, level: Settings.category.highest_level, category_order: i1.next
  c1.second.each_with_index do |c2, i2|
    cate2 = Category.create! name: c2.first, level: Settings.category.middle_level, category_order: i2.next
    CategoryRelation.create! parent_id: cate1.id, children_id: cate2.id
    unless c2.second.blank?
      c2.second.each_with_index do |c3, i3|
        cate3 = Category.create! name: c3, level: Settings.category.lowest_level, category_order: i3.next
        CategoryRelation.create! parent_id: cate2.id, children_id: cate3.id
        if Product.count <= 100
          rand_p = rand(5) + 1
          rand_p.times do |r|
            product = Product.create! name: "#{c3} #{r+1}", model: Faker::Lorem.sentence, location: Faker::Lorem.sentence,
              price: rand(10000), discount_price: rand(9000), description: Faker::Lorem.paragraph, label_order: r + 1, category_order: r + 1,
              short_description: Faker::Lorem.sentence, label_id: i3%5 + 1, brand: Brand.all.sample, parameter: Faker::Lorem.sentence
            ProductCategory.create product_id: product.id, category_id: cate3.id
          end
        end
      end
    else
      if Product.count <= 100
        rand_p = rand(5) + 1
        rand_p.times do |r|
          product = Product.create! name: "#{c2.first} #{r+1}", model: Faker::Lorem.sentence, location: Faker::Lorem.sentence,
            price: rand(10000), discount_price: rand(9000), description: Faker::Lorem.paragraph, label_order: r + 1, category_order: r + 1,
            short_description: Faker::Lorem.sentence, label_id: i2%5 + 1, brand_id: i2%50 + 1, parameter: Faker::Lorem.sentence
          ProductCategory.create product_id: product.id, category_id: cate2.id
        end
      end
    end
  end
end
puts "Create Category and Relation 1,2 OK"

puts "update home_block category"
arr = Category.where(level: Settings.category.middle_level).limit(20)
arr[0..9].each_with_index do |cat, index|
  cat.update_attributes(home_block_id: 1, home_order_id: index + 1)
end

arr[10..19].each_with_index do |cat, index|
  cat.update_attributes(home_block_id: 2, home_order_id: index + 1)
end
puts "update home_block category OK"

puts "Create template category"
5.times do |i|
  Template.create! name: Faker::Lorem.sentence[0..8], content: Faker::Lorem.paragraph
end

puts "Create 10 news articles"
15.times do |i|
  Blog.create! title: Faker::Lorem.sentence, template: Template.find(5 - rand(4)),
    content: Faker::Lorem.paragraph(30, true), is_important: [true, false].sample,
    relation_blog_id_1: rand(20) + 1, relation_blog_id_2: rand(20) + 1
end
puts "Create articles OK"

puts "Create news blog category and relation"
5.times do |i|
  bc = BlogCategory.create! id: i + 1, name: Faker::Lorem.sentence[0..8]
  10.times do |j|
    BlogCategoryRelation.create! blog: Blog.all.sample, blog_category_id: bc.id
  end
end

puts "Create blog tag and relation"
10.times do |i|
  bc = Tag.create! id: i + 1, name: Faker::Lorem.sentence[0..8]
  10.times do |j|
    BlogTagRelation.create! blog: Blog.all.sample, tag_id: bc.id
  end
end

puts "create images for news blogs"
img_files = Dir.glob "public/blog/*"
Blog.all.each_with_index do |b, i|
  2.times do |j|
    new_img = b.blog_images.build title: Faker::Lorem.sentence,
      description: Faker::Lorem.paragraph, caption: Faker::Lorem.sentence,
      alt: Faker::Lorem.sentence, is_feature: true
    File.open(img_files[(j+10)%7]) do |f|
      new_img.url = f
    end
    new_img.save!
  end
end
puts "blog images OK"

Company.create! about: Faker::Lorem.paragraph, name: Faker::Lorem.sentence,
  phone: "0987.657.234", work_time:"7AM-9PM", email:"vattuthinghiem@gmail.com",
  facebook: "http://facebook.com", instagram:"http://instagram.com",
  contact_info:"Nguyen Thanh Tu", address:"Nhà N02F, KĐT Mễ Trì Thượng, Phường Mễ Trì, Quận Nam Từ Liêm - Hà Nội",
  website:"http://thiendiahoi.com", contact_name: "Nguyen Xuan Tu"
puts "Create Company information OK"

10.times do |i|
  Tag.create! name: Faker::Lorem.word, tag_url: "http://thiendiahoi.com"
end
puts "Create Tags OK"

puts "create slider images"
slider_imgs = Dir.glob "public/jssor/*"
3.times do |i|
  img = SliderCatalog.create title: Faker::Lorem.sentence,
    desc: Faker::Lorem.paragraph, caption: Faker::Lorem.sentence,
    alt: Faker::Lorem.sentence, image_type: "slider"
  File.open(slider_imgs[i]) do |f|
    img.url = f
  end
  img.save!
end
puts "slider images OK"

puts "create catalog images"
catalog_imgs = Dir.glob "public/catalog/*"
2.times do |i|
  img = SliderCatalog.create title: Faker::Lorem.sentence,
    desc: Faker::Lorem.paragraph, caption: Faker::Lorem.sentence,
    alt: Faker::Lorem.sentence, image_type: "catalog"
  File.open(catalog_imgs[i]) do |f|
    img.url = f
  end
  img.save!
end
puts "catalog images OK"

puts "create images for products"
p_imgs = Dir.glob "public/product/*"
Product.all.each_with_index do |b, i|
  2.times do |j|
    new_img = b.product_images.build title: Faker::Lorem.sentence, url: Faker::Lorem.sentence,
      desc: Faker::Lorem.paragraph, caption: Faker::Lorem.sentence,
      alt: Faker::Lorem.sentence
    File.open(p_imgs[j]) do |f|
      new_img.url = f
    end
    new_img.save!
  end
end
puts "product images OK"

puts "create product_categories"
Category.where(level: Settings.category.lowest_level).each do |category|
  rand_p = rand(8)
  rand_p.times do |r|
    ProductCategory.create product: Product.all.sample, category_id: category.id
  end
end
puts "product_categoies OK"

puts "create product_fields"
Field.all.each do |field|
  rand_p = rand(10)
  rand_p.times do |r|
    ProductField.create product: Product.all.sample, field_id: field.id
  end
end
puts "product_fields OK"

puts "Create media..."
Medium.create!title: Faker::Lorem.sentence, description: Faker::Lorem.paragraph, url: "/uploads/media/admin_export_candidate.xlsx", media_type: 0, field_id: 2
Medium.create!title: Faker::Lorem.sentence, description: Faker::Lorem.paragraph, url: "/uploads/media/report_3.doc", media_type: 0, field_id: 2
Medium.create!title: Faker::Lorem.sentence, description: Faker::Lorem.paragraph, url: "/uploads/media/report_3.doc", media_type: 0, field_id: 1
Medium.create!title: Faker::Lorem.sentence, description: Faker::Lorem.paragraph, url: "/uploads/media/scala.pdf", media_type: 0, field_id: 2
Medium.create!title: Faker::Lorem.sentence, description: Faker::Lorem.paragraph, url: "/uploads/media/scala.pdf", media_type: 0, field_id: 3
Medium.create!title: Faker::Lorem.sentence, description: Faker::Lorem.paragraph, url: "/uploads/media/admin_export_candidate.xlsx", media_type: 0, field_id: 1
Medium.create!title: Faker::Lorem.sentence, description: Faker::Lorem.paragraph, url: "/uploads/media/report_3.doc", media_type: 0, field_id: 4
Medium.create!title: Faker::Lorem.sentence, description: Faker::Lorem.paragraph, url: "/uploads/media/report_3.doc", media_type: 0, field_id: 1
Medium.create!title: Faker::Lorem.sentence, description: Faker::Lorem.paragraph, url: "/uploads/media/scala.pdf", media_type: 0, field_id: 1
Medium.create!title: Faker::Lorem.sentence, description: Faker::Lorem.paragraph, url: "/uploads/media/scala.pdf", media_type: 0, field_id: 4

puts "Create Document's file..."
  doc_files = Dir.glob "public/media/*"
  Medium.where(media_type: 0).each_with_index do |doc, index|
    File.open(doc_files.sample) do |f|
      doc.url = f
    end
    doc.save validate: false
  end

10.times do |i|
  field = i < 5 ? 1 : 2
  Medium.create!title: Faker::Lorem.sentence, description: Faker::Lorem.paragraph, video_url: "https://www.youtube.com/embed/ptLFrU_zrEQ", media_type: 1, field_id: field
end

5.times do |i|
  Medium.find(i+1).update_attribute(:product_id, 2)
  Medium.find(i+11).update_attribute(:product_id, 2)
end
puts "Create media: doc & pdf OK"

puts "Create Brand's Logo..."
  brand_imgs = Dir.glob "public/brand/*"
  Brand.all.each_with_index do |brand, index|
    File.open(brand_imgs.sample) do |f|
      brand.image = f
    end
    brand.save validate: false
  end
puts "Logo is Okay!"

puts "Create admin"
Admin.create! email: "admin@admin.com", password: "Aa@123456", password_confirmation: "Aa@123456"
puts "Create admin OK"
