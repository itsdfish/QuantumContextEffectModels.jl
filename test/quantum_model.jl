@safetestset "Quantum Model" begin 
    @safetestset "predict" begin 
        using Distributions
        using QuantumContextEffectModels
        using Random 
        using Test
        
        Random.seed!(5874)

        dist = Dirichlet(fill(1, 4))
        for _ ∈ 1:10 
            parms = (
                Ψ = sqrt.(rand(dist)),
                θli = rand(Uniform(-1, 1)),
                θpb = rand(Uniform(-1, 1)),
            )
            
            model = QuantumModel(; parms...)
            preds = predict(
                model; 
                joint_func = get_joint_probs,
                n_way = 2
            )
            
            @test all(x -> x ≈ 1, sum.(preds))
            @test length(preds) == 6
        end
    end

    @safetestset "rand" begin 
        using Distributions
        using QuantumContextEffectModels
        using Random 
        using Test
        
        Random.seed!(6620)

        n_sim = 1000
        cnt = 0
        n_reps = 100
        df = (4 - 1) * 6

        config = (
            n_way = 2,
            joint_func = get_joint_probs,
        )

        parms = (
            Ψ = sqrt.([.25,.25,.3,.2]),
            θli = -.2,
            θpb = .1,
        )

        for _ ∈ 1:n_reps 
            # parameters such that expected responses ≥ 5
         
            model = QuantumModel(; parms...)
            responses = vcat(rand(model, n_sim; config...)...)
            expected_responses = vcat(predict(model; config...) * n_sim...)
            Χ² = sum((responses .- expected_responses).^2 ./ expected_responses)
            cnt += (1 - cdf(Chisq(df), Χ²)) ≤ .05 ? 1 : 0
        end
        @test 1 - cdf(Binomial(n_reps, .05), cnt) ≥ .05
    end
end

@safetestset "unitary transformation" begin 
    using QuantumContextEffectModels
    using QuantumContextEffectModels: U
    using Test

    m = U(.5)
    @test m ≈ [0 -1; 1 0]

    m = U(-.5)
    @test m ≈ [0 1; -1 0]
end

@safetestset "unitary transformation" begin 
    using QuantumContextEffectModels
    using QuantumContextEffectModels: get_joint_prob
    using Test

    P₁ = [1 0 0 0;
          0 1 0 0;
          0 0 0 0
          0 0 0 0]

    P₂ = [1 0 0 0;
          0 0 0 0;
          0 0 0 0;
          0 0 0 0]

    Ψ = sqrt.([.3,.5,.1,.1])
    parms = (
        Ψ,
        θli = -.2,
        θpb = .1,
    )
    model = QuantumModel(; parms...)

    prob = get_joint_prob(model, [P₁, P₂], Ψ)
    @test prob ≈ .30

    prob = get_joint_prob(model, [P₂, P₁], Ψ)
    @test prob ≈ .30
end

@safetestset "order effects" begin 
    using QuantumContextEffectModels
    using Test

    parms = (
        Ψ = sqrt.([.3,.1,.2,.4]),
        θli = .3,
        θpb = .3,
    )
    
    model = QuantumModel(; parms...)
    preds = predict(model; n_way = 2)
   
    # believable and informative are compatible 
    @test preds[1][1] ≈ preds[1][2]
    # believable and persuasive are incompatible 
    @test !(preds[2][1] ≈ preds[2][2])
    # believable and likeable are compatible 
    @test preds[3][1] ≈ preds[3][2]
    # informative and persuasive are compatible 
    @test preds[4][1] ≈ preds[4][2]
    # informative and likable are incompatible 
    @test !(preds[5][1] ≈ preds[5][2])
    # persuasive and likeable are compatible 
    @test preds[6][1] ≈ preds[6][2]
end

@safetestset "logpdf" begin 
    @safetestset "no order" begin 
        using QuantumContextEffectModels
        using Random 
        using Test

        Random.seed!(5774)

        Ψ = sqrt.([.3,.1,.2,.4])
        θli = .3
        θpb = .3

        parms = (;Ψ, θli, θpb)

        n_trials = 10_000
        model = QuantumModel(; parms...)
        data = rand(
            model,
            n_trials;
            n_way = 2,
            joint_func = get_joint_probs
        )
        
        θlis = range(.8 * θli, 1.2 * θli, length=100)
        LLs = map(θli -> logpdf(QuantumModel(; parms..., θli), data, n_trials; n_way=2), θlis)
        _,idx = findmax(LLs)
        @test θlis[idx] ≈ θli atol = 1e-2

        θpbs = range(.8 * θpb, 1.2 * θpb, length=100)
        LLs = map(θpb -> logpdf(QuantumModel(; parms..., θpb), data, n_trials; n_way=2), θpbs)
        _,idx = findmax(LLs)
        @test θlis[idx] ≈ θli atol = 1e-2
    end

    @safetestset "order" begin 
        using QuantumContextEffectModels
        using Random 
        using Test

        Random.seed!(5774)
        
        Ψ = sqrt.([.3,.1,.2,.4])
        θli = .3
        θpb = .3

        parms = (;Ψ, θli, θpb)

        n_trials = 10_000
        model = QuantumModel(; parms...)
        data = rand(model, n_trials; n_way=2)
        
        θlis = range(.8 * θli, 1.2 * θli, length=100)
        LLs = map(θli -> logpdf(QuantumModel(; parms..., θli), data, n_trials; n_way=2), θlis)
        _,idx = findmax(LLs)
        @test θlis[idx] ≈ θli atol = 1e-2

        θpbs = range(.8 * θpb, 1.2 * θpb, length=100)
        LLs = map(θpb -> logpdf(QuantumModel(; parms..., θpb), data, n_trials; n_way=2), θpbs)
        _,idx = findmax(LLs)
        @test θlis[idx] ≈ θli atol = 1e-2
    end
end