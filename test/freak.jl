using Test, ImageFeatures, Images, TestImages, Distributions

@testset "Test freak params" begin
    freak_params = FREAK(pattern_scale = 20.0)
    @test freak_params.pattern_scale == 20.0
    pt, st = ImageFeatures._freak_tables(20.0)
    @test freak_params.pattern_table == pt
    @test freak_params.smoothing_table == st
end

@testset "Testing with Standard Images - Lighthouse (Rotation 45)" begin
    img = testimage("lighthouse")
    img_array_1 = Gray.(img)
    img_array_2 = _warp(img_array_1, pi / 4)

    keypoints_1 = Keypoints(fastcorners(img_array_1, 12, 0.35))
    keypoints_2 = Keypoints(fastcorners(img_array_2, 12, 0.35))
    freak_params = FREAK()

    desc_1, ret_keypoints_1 = create_descriptor(img_array_1, keypoints_1, freak_params)
    desc_2, ret_keypoints_2 = create_descriptor(img_array_2, keypoints_2, freak_params)
    matches = match_keypoints(ret_keypoints_1, ret_keypoints_2, desc_1, desc_2, 0.1)
    reverse_keypoints_1 = [_reverserotate(m[1], pi / 4, (256, 384)) for m in matches]
    @test sum(isapprox(rk[1], m[2][1], atol = 4) && isapprox(rk[2], m[2][2], atol = 4) for (rk, m) in zip(reverse_keypoints_1, matches)) >= length(matches) - 1
end

@testset "Testing with Standard Images - Lighthouse (Rotation 45, Translation (50, 40))" begin
    img = testimage("lighthouse")
    img_array_1 = Gray.(img)
    img_temp_2 = _warp(img_array_1, pi / 4)
    img_array_2 = _warp(img_temp_2, 50, 40)

    keypoints_1 = Keypoints(fastcorners(img_array_1, 12, 0.35))
    keypoints_2 = Keypoints(fastcorners(img_array_2, 12, 0.35))
    freak_params = FREAK()

    desc_1, ret_keypoints_1 = create_descriptor(img_array_1, keypoints_1, freak_params)
    desc_2, ret_keypoints_2 = create_descriptor(img_array_2, keypoints_2, freak_params)
    matches = match_keypoints(ret_keypoints_1, ret_keypoints_2, desc_1, desc_2, 0.1)
    reverse_keypoints_1 = [_reverserotate(m[1], pi / 4, (256, 384)) + CartesianIndex(50, 40) for m in matches]
    @test sum(isapprox(rk[1], m[2][1], atol = 3) && isapprox(rk[2], m[2][2], atol = 3) for (rk, m) in zip(reverse_keypoints_1, matches)) >= length(matches) - 1
end

@testset "Testing with Standard Images - Lighthouse (Rotation 75, Translation (50, 40))" begin
    img = testimage("lighthouse")
    img_array_1 = Gray.(img)
    img_temp_2 = _warp(img_array_1, 5 * pi / 6)
    img_array_2 = _warp(img_temp_2, 50, 40)

    keypoints_1 = Keypoints(fastcorners(img_array_1, 12, 0.35))
    keypoints_2 = Keypoints(fastcorners(img_array_2, 12, 0.35))
    freak_params = FREAK()

    desc_1, ret_keypoints_1 = create_descriptor(img_array_1, keypoints_1, freak_params)
    desc_2, ret_keypoints_2 = create_descriptor(img_array_2, keypoints_2, freak_params)
    matches = match_keypoints(ret_keypoints_1, ret_keypoints_2, desc_1, desc_2, 0.1)
    reverse_keypoints_1 = [_reverserotate(m[1], 5 * pi / 6, (256, 384)) + CartesianIndex(50, 40) for m in matches]
    @test sum(isapprox(rk[1], m[2][1], atol = 4) && isapprox(rk[2], m[2][2], atol = 4) for (rk, m) in zip(reverse_keypoints_1, matches)) >= length(matches) - 1
end

@testset "Testing with Standard Images - Lena (Rotation 45, Translation (10, 20))" begin
    img = testimage("lena_gray_512")
    img_array_1 = Gray.(img)
    img_temp_2 = _warp(img_array_1, pi / 4)
    img_array_2 = _warp(img_temp_2, 10, 20)

    keypoints_1 = Keypoints(fastcorners(img_array_1, 12, 0.2))
    keypoints_2 = Keypoints(fastcorners(img_array_2, 12, 0.2))
    freak_params = FREAK()

    desc_1, ret_keypoints_1 = create_descriptor(img_array_1, keypoints_1, freak_params)
    desc_2, ret_keypoints_2 = create_descriptor(img_array_2, keypoints_2, freak_params)
    matches = match_keypoints(ret_keypoints_1, ret_keypoints_2, desc_1, desc_2, 0.1)
    reverse_keypoints_1 = [_reverserotate(m[1], pi / 4, (256, 256)) + CartesianIndex(10, 20) for m in matches]
    @test isapprox(sum(isapprox(rk[1], m[2][1], atol = 4) && isapprox(rk[2], m[2][2], atol = 4) for (rk, m) in zip(reverse_keypoints_1, matches)), length(matches), atol = 2)
end
